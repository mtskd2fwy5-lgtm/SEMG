"""Compare Q24 sequencer against frozen float reference and emit RTL vectors."""
from pathlib import Path
import json, math, argparse
from imu_fixed_model import Model,ROOT,ROM

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--limit',type=int,default=0);args=ap.parse_args()
    report=ROOT/'report/imu_pl_20261028'
    m=Model();count=0;maxerr=0;maxangle=0;maxbias=0;resets=0
    replay=[];differences=[]
    for lineno,line in enumerate((report/'imu_float_vectors.txt').read_text().splitlines(),1):
        f=line.split()
        if f[0]=='R':m.reset();replay.append('R');resets+=1;continue
        a,b,c,w=[int(v,16) for v in f[1:5]];gap=int(f[5]);z,zc,stationary,rv,angle,reason,gaps,clips,samples,dt=map(int,f[6:16])
        mat=list(map(int,f[16:25]));bias=list(map(float,f[25:28]))
        r=m.sample(a,b,c,(w>>24)&127,gap)
        # Floating reference preserves its diagnostic totals and thermal bias
        # on manual reset. PL deliberately clears all state on reset.
        err=max(abs(x-y) for x,y in zip(r[3:12],mat))/4096
        maxerr=max(maxerr,err)
        expected_flags=(z<<1)|(stationary<<3)|(rv<<2)|1
        if (r[1]&15)!=expected_flags or ((r[1]>>8)&127)!=zc or err>.006 or (rv and abs(r[12]-angle)>2):
            differences.append(dict(line=lineno,flags=r[1]&15,expect=expected_flags,count=(r[1]>>8)&127,
                                    expect_count=zc,error=err,angle=r[12],expect_angle=angle,reason=(r[1]>>16)&127,expect_reason=reason))
            if len(differences)>9:break
        if rv:maxangle=max(maxangle,abs(r[12]-angle))
        # Exact Q24 outputs for independent RTL / synthesized netlist replay.
        replay.append('S '+' '.join(f'{v&0xffffffff:08x}' for v in [a,b,c,w,gap,*r]))
        count+=1
        if args.limit and count>=args.limit:break
    (report/'float_comparison.json').write_text(json.dumps(dict(samples=count,resets=resets,
        max_matrix_component_error=maxerr,max_twist_error_degrees=maxangle,differences=differences),indent=2))
    if differences:
        print(json.dumps(differences[:10],indent=2));raise SystemExit('FLOAT_COMPARISON_FAIL')
    (report/'imu_rtl_vectors.txt').write_text('\n'.join(replay)+'\n')
    # Same ROM for the test-only C interpreter used by LCD integration tests.
    from imu_fixed_model import META
    (ROOT/'sim/imu_program.h').write_text('#include <stdint.h>\n#define IMU_TEST_START '+str(META['start'])+'\nstatic const uint64_t imu_test_rom[]={\n'+
        ',\n'.join(f'UINT64_C(0x{v:016x})' for v in ROM)+'\n};\n')
    print(f'TEST_PASS Q24/float reference samples={count} resets={resets} matrix_error={maxerr:.6f} twist_error={maxangle}deg')

if __name__=='__main__':main()
