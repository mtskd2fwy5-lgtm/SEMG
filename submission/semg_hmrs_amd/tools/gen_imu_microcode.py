"""Generate the dedicated Q24 attitude sequencer ROM (no CPU/firmware core).

The independent float fusion originates in report/imu_pl_20261028/baseline;
gen_imu_reference.py applies the current relative-zero coordinate contract.
Arithmetic is serialized because the sensor supplies only 100 frames/second.
Run this generator before simulation/build; generated ROM is tracked RTL.
"""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]
Q = 1 << 24
OPS = dict(MOV=1, LDI=2, ADD=3, SUB=4, MUL=5, DIV=6, SQRT=7,
           NEG=8, ABS=9, SHR=10, BAND=11, BOR=12, JMP=13,
           EQ=14, NE=15, LT=16, LE=17, GT=18, GE=19,
           WAIT=20, PUBLISH=21, CALL=22, RET=23, IN=24, OUT=25)
code, labels, names, constants = [], {}, {}, {}
free = list(range(255, 207, -1))
nextreg = 0
unique = 0

class E:
    def __init__(self, op, *args): self.op,self.args = op,args
    def __add__(self,b): return E('ADD',self,b)
    def __radd__(self,b): return E('ADD',b,self)
    def __sub__(self,b): return E('SUB',self,b)
    def __rsub__(self,b): return E('SUB',b,self)
    def __mul__(self,b): return E('MUL',self,b)
    def __rmul__(self,b): return E('MUL',b,self)
    def __truediv__(self,b): return E('DIV',self,b)
    def __rtruediv__(self,b): return E('DIV',b,self)
    def __neg__(self): return E('NEG',self)

class R(E):
    def __init__(self,n): self.n=n

def var(name):
    global nextreg
    assert nextreg<208, 'persistent register bank exhausted'
    r=R(nextreg); names[name]=r.n; nextreg+=1
    return r
def arr(name,n): return [var(f'{name}{i}') for i in range(n)]
def emit(op,d=0,a=0,b=0,imm=0): code.append([op,d,a,b,imm])
def label(s):
    assert s not in labels
    labels[s]=len(code)
def fresh():
    global unique
    unique+=1
    return f'L{unique}'
def c(v):
    # Floats represent Q24; integers are raw integers (counters/masks).
    n=round(v*Q) if isinstance(v,float) else v
    if n not in constants:
        constants[n]=var(f'constant_{n}')
    return constants[n]
def comp(e):
    if not isinstance(e,E): return c(e).n,False
    if isinstance(e,R): return e.n,False
    a,ta=comp(e.args[0]); b,tb=comp(e.args[1]) if len(e.args)>1 else (0,False)
    d=free.pop()
    emit(e.op,d,a,b,24 if e.op=='MUL' else 0)
    if ta: free.append(a)
    if tb: free.append(b)
    return d,True
def put(d,e):
    r,t=comp(e)
    if d.n!=r: emit('MOV',d.n,r)
    if t: free.append(r)
def jump(s): emit('JMP',imm=s)
def branch(op,a,b,s):
    x,tx=comp(a); y,ty=comp(b);emit(op,a=x,b=y,imm=s)
    if tx: free.append(x)
    if ty: free.append(y)
def call(s): emit('CALL',imm=s)
def ret(): emit('RET')
def shr(a,n): return E('SHR',a,n)
def abs_(a): return E('ABS',a)
def sqrt(a): return E('SQRT',a)
def bor(a,b): return E('BOR',a,b)
def band(a,b): return E('BAND',a,b)
def dot(a,b): return a[0]*b[0]+a[1]*b[1]+a[2]*b[2]
def cross(a,b): return [a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]]
def copy(a,b):
    for x,y in zip(a,b): put(x,y)
def quatmul(d,a,b):
    tmp=arr('quat_tmp'+fresh(),4) if False else work4
    w,x,y,z=a; W,X,Y,Z=b
    copy(tmp,[w*W-x*X-y*Y-z*Z,w*X+x*W+y*Z-z*Y,
              w*Y-x*Z+y*W+z*X,w*Z+x*Y-y*X+z*W])
    copy(d,tmp)
def norm(v):
    # Guard the reciprocal by four Q24 LSBs for the truncated square terms
    # and root. This avoids systematic norm growth in repeated updates.
    put(k,1.0/(sqrt(sum((x*x for x in v),c(0.0)))+4))
    copy(v,[x*k for x in v])

# Fixed register locations are emitted as an include for RTL and host tooling.
acc=arr('acc',3); raw=arr('raw',3)
seq=var('seq'); gap=var('gap'); step=var('step'); lastseq=var('lastseq')
valid=var('valid'); zero_valid=var('zero_valid'); count=var('zero_count')
reason=var('reason'); stationary=var('stationary'); stillticks=var('stillticks')
samplecount=var('samplecount'); gaps=var('gaps'); clips=var('clips'); restarts=var('restarts')
dt=var('dt'); dtms=var('dtms'); still=var('still'); filtervalid=var('filtervalid')
prevvalid=var('prevvalid'); q=arr('q',4); zero=arr('zero',4); rel=arr('rel',4)
bias=arr('bias',3); biassum=arr('biassum',3); accsum=arr('accsum',3)
prevacc=arr('prevacc',3); filtacc=arr('filtacc',3); filtrate=arr('filtrate',3); anchor=arr('anchor',3)
up=arr('up',3); forward=arr('forward',3); right=arr('right',3)
an=var('an'); delta=var('delta'); zdelta=var('zdelta'); rdelta=var('rdelta'); travel=var('travel')
k=var('k'); d=var('d'); olda=var('olda'); oldr=var('oldr')
g=arr('g',3); v=arr('v',3); e=arr('e',3); en=var('en')
wa=arr('wa',3); work4=arr('work4',4); dq=arr('dq',4)
h=var('h'); n=var('n'); j=var('j'); matrix=arr('matrix',9)
rotvalid=var('rotvalid'); rotseen=var('rotseen'); rotraw=var('rotraw'); unwrap=var('unwrap'); angle=var('angle')
lo=var('lo'); hi=var('hi'); mid=var('mid'); s=var('s'); co=var('co'); sn=var('sn'); cs=var('cs')
tmp=var('tmp'); tmp2=var('tmp2')

label('loop');emit('WAIT')
for i,r in enumerate([*acc,*raw,seq,gap]): emit('IN',r.n,imm=i)
# Convert +/-1000 dps gyro integers to radians/s with <1e-8 relative
# coefficient quantization, sharing the sequencer's multiplier.
gyro_factor=c(round((0.01745329252/32.8)*Q*1024))
for r in raw: emit('MUL',r.n,r.n,gyro_factor.n,10)
put(an,dot(acc,acc));put(step,band(seq-lastseq,127));put(dt,0.0);put(still,0)
branch('NE',valid,0,'have_attitude')
branch('LT',an,0.5,'loop');branch('GT',an,1.5,'loop')
copy(wa,acc);call('gravity');copy(zero,q);call('basis')
put(valid,1);put(step,0);put(prevvalid,0)
label('have_attitude')
branch('EQ',gap,0,'no_gap');put(gaps,gaps+1);jump('dt_done')
label('no_gap');branch('GT',step,8,'seq_gap');put(dt,step*c(0.01));jump('dt_done')
label('seq_gap');put(gaps,gaps+1)
label('dt_done');put(lastseq,seq);put(samplecount,samplecount+1)
# Fixed multiplication by integer step uses unscaled multiplication.
# Correct the preceding mixed-scale expression explicitly.
# dt=step*0.01 is encoded by MUL with shift 0.
for ins in code:
    if ins[0]=='MUL' and ins[2]==step.n: ins[4]=0
put(dtms,dt/c(0.001));put(dtms,shr(dtms,24))
put(reason,0);branch('NE',dt,0,'dt_nonzero');put(reason,1)
label('dt_nonzero')
branch('LE',an,0.90,'bad_norm');branch('GE',an,1.10,'bad_norm');jump('norm_ok')
label('bad_norm');put(reason,bor(reason,2))
label('norm_ok');put(still,prevvalid)
branch('EQ',band(reason,3),0,'still_norm_ok');put(still,0)
label('still_norm_ok');put(delta,0.0);put(zdelta,0.0);put(rdelta,0.0)
put(k,dt/(c(0.05)+dt))
for i in range(3):
    put(olda,filtacc[i]);put(oldr,filtrate[i]);skip=fresh();done=fresh()
    branch('LE',abs_(raw[i]-bias[i]),0.8*0.01745329252,skip);put(still,0);label(skip)
    branch('EQ',filtervalid,0,done);branch('EQ',dt,0,done)
    put(filtacc[i],filtacc[i]+(acc[i]-filtacc[i])*k)
    put(filtrate[i],filtrate[i]+(raw[i]-filtrate[i])*k);skip=fresh();jump(skip)
    label(done);put(filtacc[i],acc[i]);put(filtrate[i],raw[i]);label(skip)
    put(zdelta,zdelta+(filtacc[i]-olda)*(filtacc[i]-olda))
    put(rdelta,rdelta+(filtrate[i]-oldr)*(filtrate[i]-oldr))
    skip=fresh();branch('LE',abs_(raw[i]-bias[i]),20*0.01745329252,skip)
    put(reason,bor(reason,4));label(skip)
    put(delta,delta+(acc[i]-prevacc[i])*(acc[i]-prevacc[i]));put(prevacc[i],acc[i])
    skip=fresh();branch('LT',abs_(raw[i]),32700*0.01745329252/32.8,skip)
    put(clips,clips+1);put(reason,bor(reason,64));label(skip)
skip=fresh();branch('LE',delta,0.0001,skip);put(still,0);label(skip)
skip=fresh();branch('EQ',filtervalid,0,skip)
done=fresh();branch('LE',zdelta,0.0001,done);put(reason,bor(reason,8));label(done)
done=fresh();branch('LE',rdelta,256*(0.01745329252/32.8)**2,done);put(reason,bor(reason,4));label(done);label(skip)
put(filtervalid,1);put(prevvalid,1)
skip=fresh();done=fresh();branch('EQ',still,0,skip);branch('EQ',step,0,skip)
put(stillticks,stillticks+step);jump(done);label(skip);put(stillticks,0);label(done)
put(stationary,0);skip=fresh();branch('LT',stillticks,50,skip);put(stationary,1);label(skip)
branch('NE',zero_valid,0,'adapt_bias')
put(travel,0.0)
for i in range(3):
    skip=fresh();branch('NE',count,0,skip);put(anchor[i],filtacc[i]);label(skip)
    put(travel,travel+(filtacc[i]-anchor[i])*(filtacc[i]-anchor[i]))
skip=fresh();branch('LE',travel,0.0004,skip);put(reason,bor(reason,16));label(skip)
branch('EQ',reason,0,'accumulate_zero')
skip=fresh();branch('EQ',count,0,skip);put(restarts,restarts+1);label(skip)
put(count,0);copy(biassum,[0.0]*3);copy(accsum,[0.0]*3);jump('fuse')
label('accumulate_zero')
for i in range(3): put(biassum[i],biassum[i]+raw[i]);put(accsum[i],accsum[i]+acc[i])
put(count,count+1);branch('LT',count,100,'fuse')
for i in range(3): put(bias[i],biassum[i]*c(0.01));put(wa[i],accsum[i]*c(0.01))
call('gravity');copy(zero,q);call('basis');put(zero_valid,1);put(dt,0.0);jump('fuse')
label('adapt_bias');branch('EQ',stationary,0,'fuse')
put(k,dt);skip=fresh();branch('LE',k,0.08,skip);put(k,0.08);label(skip)
for i in range(3): put(bias[i],bias[i]+(raw[i]-bias[i])*k)
label('fuse');copy(g,[0.0]*3);branch('NE',stationary,0,'gravity_feedback')
copy(g,[raw[i]-bias[i] for i in range(3)])
label('gravity_feedback');branch('LE',an,0.94,'integrate');branch('GE',an,1.06,'integrate')
copy(wa,acc);norm(wa)
copy(v,[c(2.0)*(q[1]*q[3]-q[0]*q[2]),c(2.0)*(q[2]*q[3]+q[0]*q[1]),c(1.0)-c(2.0)*(q[1]*q[1]+q[2]*q[2])])
copy(e,cross(wa,v));put(en,dot(e,e));put(k,0.1)
# Divide rates by 4 before squaring: prevents overflow at +/-1000 dps.
put(tmp,sum(((x*c(0.25))*(x*c(0.25)) for x in g),c(0.0)))
skip=fresh();branch('GE',tmp,0.25/16,skip);put(k,0.5);label(skip)
skip=fresh();branch('EQ',stationary,0,skip);put(k,5.0);label(skip)
skip=fresh();branch('LE',k*k*en,0.0625,skip);put(k,c(0.25)/sqrt(en));label(skip)
copy(g,[g[i]+k*e[i] for i in range(3)])
label('integrate');branch('EQ',dt,0,'relative')
put(tmp,dt/c(0.005));put(n,shr(tmp,24)+1)
# h = 0.5*dt/n, integer n is converted to Q24 by left shift.
put(tmp,E('SHR',n,-24));put(h,c(0.5)*dt/tmp);put(j,0)
label('integrate_loop');quatmul(dq,q,[0.0,*g])
copy(q,[q[i]+h*dq[i] for i in range(4)]);norm(q)
put(j,j+1);branch('LT',j,n,'integrate_loop')
label('relative');quatmul(rel,[zero[0],-zero[1],-zero[2],-zero[3]],q);norm(rel)
# Full 3-D rotation, independent of Euler folding at +/-90 degrees.
w,x,y,z=rel
copy(matrix,[c(1.0)-c(2.0)*(y*y+z*z),c(2.0)*(x*y-w*z),c(2.0)*(x*z+w*y),
             c(2.0)*(x*y+w*z),c(1.0)-c(2.0)*(x*x+z*z),c(2.0)*(y*z-w*x),
             c(2.0)*(x*z-w*y),c(2.0)*(y*z+w*x),c(1.0)-c(2.0)*(x*x+y*y)])
for i in range(3):
    copy(v,[-matrix[i],-matrix[3+i],-matrix[6+i]])
    copy(work4[:3],[dot(right,v),dot(forward,v),-dot(up,v)])
    for j in range(3): put(matrix[3*j+i],shr(work4[j],12))
# Swing/twist, same 15-degree interpolated sine table as LCD reference.
put(rotvalid,0);branch('EQ',zero_valid,0,'publish')
branch('LT',w*w+y*y,0.01,'publish')
put(s,abs_(c(2.0)*w*y));put(co,w*w-y*y);put(lo,0);put(hi,180)
label('angle_loop');branch('GE',lo,hi,'angle_done');put(mid,shr(lo+hi,1))
put(tmp,mid);call('sin_q12');put(sn,tmp)
put(tmp,90-mid);call('sin_q12');put(cs,tmp)
# sn/cs are integer Q12. Convert to Q24 before fixed multiplication.
put(tmp,s*E('SHR',cs,-12)-co*E('SHR',sn,-12))
skip=fresh();done=fresh();branch('LE',tmp,0,skip);put(lo,mid+1);jump(done)
label(skip);put(hi,mid);label(done);jump('angle_loop')
label('angle_done');put(tmp,lo)
skip=fresh();branch('LE',w*y,0,skip);put(tmp,-lo);label(skip)
branch('NE',rotseen,0,'unwrap');put(unwrap,tmp);put(rotseen,1);jump('unwrapped')
label('unwrap');put(d,tmp-rotraw)
skip=fresh();branch('LE',d,180,skip);put(d,d-360);label(skip)
skip=fresh();branch('GE',d,-180,skip);put(d,d+360);label(skip)
put(unwrap,unwrap+d)
label('unwrapped');put(rotraw,tmp);put(angle,unwrap)
skip=fresh();branch('LE',angle,225,skip);put(angle,225);label(skip)
skip=fresh();branch('GE',angle,-45,skip);put(angle,-45);label(skip)
put(rotvalid,1)
label('publish')
put(tmp,bor(bor(valid,E('SHR',zero_valid,-1)),bor(E('SHR',rotvalid,-2),E('SHR',stationary,-3))))
put(tmp,bor(bor(tmp,E('SHR',count,-8)),E('SHR',reason,-16)))
outputs={0:c(0x17494d55),1:tmp,2:samplecount,
         **{3+i:r for i,r in enumerate(matrix)},12:angle,
         **{13+i:r for i,r in enumerate(bias)},16:gaps,17:clips,18:restarts,
         19:dtms,20:stillticks,21:seq,**{22+i:r for i,r in enumerate(q)},29:rotraw}
for index,r in outputs.items(): emit('OUT',a=r.n,imm=index)
emit('PUBLISH');jump('loop')

label('gravity')
norm(wa);branch('LT',wa[2],0,'lower_gravity')
copy(q,[c(1.0)+wa[2],wa[1],-wa[0],0.0]);jump('gravity_normalize')
label('lower_gravity');copy(q,[wa[1],c(1.0)-wa[2],0.0,wa[0]])
label('gravity_normalize');norm(q);ret()
# The relative quaternion already removes the captured sensor attitude.
# Use a fixed palm-up display basis; applying captured gravity here would
# reintroduce the absolute tilt/face and prevent a true calibration zero.
label('basis');copy(up,[0.0,0.0,-1.0]);copy(forward,[0.0,-1.0,0.0])
copy(right,[1.0,0.0,0.0]);ret()

label('sin_q12')
# Only arguments [-90,180] are needed by the twist bisection.
put(tmp2,1);skip=fresh();branch('GE',tmp,0,skip);put(tmp,-tmp);put(tmp2,-1);label(skip)
skip=fresh();branch('LE',tmp,90,skip);put(tmp,180-tmp);label(skip)
table=[0,1059,2048,2896,3547,3951,4096]
for i in range(6):
    skip=fresh();branch('GT',tmp,(i+1)*15,skip)
    # Integer interpolation: raw multiply, integer division implemented
    # with Q24 DIV then >>24 (quotient never exceeds 4096).
    put(tmp,(tmp-i*15)*c(table[i+1]-table[i]))
    # Mark the sole multiplication in this expression as unscaled.
    for ins in reversed(code):
        if ins[0]=='MUL': ins[4]=0;break
    # Quotient may exceed the Q24 range. Integer divide uses DIV shift 0.
    emit('DIV',tmp.n,tmp.n,c(15).n,1)
    put(tmp,tmp+table[i]);jump('sin_sign');label(skip)
put(tmp,4096)
label('sin_sign');skip=fresh();branch('GE',tmp2,0,skip);put(tmp,-tmp);label(skip);ret()

# Constants are initialized once after hardware clears the register RAM.
start=len(code)
for value,r in constants.items(): emit('LDI',r.n,imm=value)
jump('loop')
assert nextreg<208 and len(code)<2048,(nextreg,len(code))
resolved=[]
for op,d,a,b,imm in code:
    if isinstance(imm,str): imm=labels[imm]
    resolved.append((OPS[op]<<56)|(d<<48)|(a<<40)|(b<<32)|(imm&0xffffffff))
out=ROOT/'src/rtl/mpu_attitude_rom.vh'
out.write_text('// Generated by tools/gen_imu_microcode.py; Q24, do not edit.\n'+
    '\n'.join(f"rom[{i}] = 64'h{v:016x};" for i,v in enumerate(resolved))+'\n')
defs=ROOT/'src/rtl/mpu_attitude_regs.vh'
defs.write_text('// Generated register locations.\n'+
    f'localparam IMU_START={start}, IMU_WORDS={len(code)};\n'+
    '\n'.join(f'localparam R_{name.upper()}={r};' for name,r in names.items() if not name.startswith('constant'))+'\n')
manifest=dict(q=24,start=start,words=len(code),registers=names,opcodes=OPS,labels=labels)
(ROOT/'sim/imu_program.json').write_text(json.dumps(manifest,indent=2))
print(f'IMU_ROM_GENERATED words={len(code)} persistent={nextreg} Q24')

