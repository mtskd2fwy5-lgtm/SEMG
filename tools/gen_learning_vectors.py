"""Independent integer NMF/HDC golden stimuli for the RTL DDR accelerator."""
from pathlib import Path
import re, random
ROOT=Path(__file__).resolve().parents[1]
W=[[1924,8720,119],[1732,8434,127],[16985,18060,30732],[443,7281,21],
   [27208,17077,10392],[5724,11898,4605],[2288,7531,157],[332,7583,137]]
G=[[(sum(r[j]*r[k] for r in W)+16384)>>15 for k in range(3)] for j in range(3)]
def nmf(e):
    x=[min(v,0x7fffffff)*256//400 for v in e]
    wt=[(sum(W[i][j]*x[i] for i in range(8))+16384)>>15 for j in range(3)]
    c=[v//3 for v in wt]
    for _ in range(8):
        den=[(sum(G[j][k]*max(c[k],1) for k in range(3))+16384)>>15 for j in range(3)]
        c=[min(0x7fffffff,(max(c[j],1)*wt[j]+den[j]//2)//den[j]) if den[j] and wt[j] else 0 for j in range(3)]
    mean=[min(v,0x7fffffff)//400 for v in e]
    rec=[(sum(W[i][j]*c[j] for j in range(3))+4194304)>>23 for i in range(8)]
    return c+[min(100,v*100//r) for v,r in zip(c,[14592,50432,11008])]+[sum(abs(a-b) for a,b in zip(mean,rec))*100//sum(mean) if sum(mean) else 0,1]
def generate(quick=False):
    rng=random.Random(20261026)
    model=(ROOT/'sw/ps_uart_print/synergy_nmf_model.h').read_text()
    weights=model.split('synergy_w_q15[8][3] = {',1)[1].split('};',1)[0]
    assert list(map(int,re.findall(r'(\d+)u',weights)))==sum(W,[]),'NMF C/RTL basis contract changed'
    refs=model.split('synergy_display_ref[3] = {',1)[1].split('}',1)[0]
    assert list(map(int,re.findall(r'(\d+)u',refs)))==[14592,50432,11008],'NMF display reference changed'
    memory=[int(v,16) for v in re.findall(r'0x([0-9a-f]{8})u',(ROOT/'sw/ps_uart_print/hdc_memory.h').read_text())]
    assert len(memory)==4096
    assert (ROOT/'data/models/hdc_memory.mem').read_text().splitlines()==[f'{v:08x}' for v in memory]
    def encode(e,scale,levels=32):
        qlevels=[min(levels-1,(v*(levels-1)+max(s,1)//2)//max(s,1)) for v,s in zip(e,scale)]
        base=1536 if levels==32 else 0
        q=[]
        for w in range(64):
            votes=[(~(memory[base+ch*64+w]^memory[base+512+qlevels[ch]*64+w]))&0xffffffff for ch in range(8)]
            q.append(sum((sum((v>>b)&1 for v in votes)>=4)<<b for b in range(32)))
        return q
    es=[[0]*8,[1]*8,[0x7fffffff]*8,[0xffffffff]*8]+[[rng.randrange(0,10**rng.randrange(1,9)) for _ in range(8)] for _ in range(60)]
    data=[len(es)]
    for e in es:data+=e+nmf(e)
    batch=[[rng.randrange(10000,200000) for _ in range(8)] for _ in range(3)]
    scale=[max(row[ch] for row in batch) for ch in range(8)]
    data+=sum(batch,[])+scale
    protos=[]
    training=[]
    for cls in range(6):
        p=[0]*2048
        for _ in range(4 if quick else 120):
            e=[s*((11 if ch%6==cls else 2)+rng.randrange(3))//15 for ch,s in enumerate(scale)]
            training.append(e);data+=e
            q=encode(e,scale)
            p=[v+(1 if (q[d//32]>>(d%32))&1 else -1) for d,v in enumerate(p)]
        data += [(p[i]&65535)|((p[i+1]&65535)<<16) for i in range(0,2048,2)]
        protos.append(p)
    # Netlist mode retains every class and both amplitude boundaries; the
    # full RTL suite checks four different queries per class.
    tests=(training[::4] if quick else training[::30])+[[0]*8,[0xffffffff]*8]
    data.append(len(tests))
    for e in tests:
        q=encode(e,scale)
        sims=[sum(v*(1 if (q[d//32]>>(d%32))&1 else -1) for d,v in enumerate(p)) for p in protos]
        order=sorted(range(6),key=lambda c:-sims[c])
        data+=e+[order[0],(sims[order[0]]-sims[order[1]])*100//491520,sum(a>b for a,b in zip(e,scale)),(sims[order[0]]-sims[order[1]])*10000//491520]
    # Legacy Q16 ROM must remain bit-exact, including after running Q32 jobs.
    legacy_e=[s*(ch+1)//10 for ch,s in enumerate(scale)]
    q=encode(legacy_e,scale,16)
    legacy_proto=[1 if (q[d//32]>>(d%32))&1 else -1 for d in range(2048)]
    data+=legacy_e+[(legacy_proto[i]&65535)|((legacy_proto[i+1]&65535)<<16) for i in range(0,2048,2)]
    out=ROOT/'sim/results_learning' ;out.mkdir(exist_ok=True)
    (out/'learning_vectors.mem').write_text('\n'.join(f'{v:08x}' for v in data)+'\n')
    print(f'TEST_PASS generated independent golden: {len(es)} NMF, {len(training)} training, {len(tests)} HDC predictions')
if __name__=='__main__':
    import argparse
    ap=argparse.ArgumentParser();ap.add_argument('--quick',action='store_true');args=ap.parse_args()
    generate(args.quick)
