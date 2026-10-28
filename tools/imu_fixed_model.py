"""Bit-exact interpreter for the dedicated PL attitude sequencer ISA.

Verification only. The board application never executes this interpreter.
"""
from pathlib import Path
import json, math, re

ROOT=Path(__file__).resolve().parents[1]
META=json.loads((ROOT/'sim/imu_program.json').read_text())
ROM=[int(x,16) for x in re.findall(r"64'h([0-9a-f]+)",(ROOT/'src/rtl/mpu_attitude_rom.vh').read_text())]
OPS={v:k for k,v in META['opcodes'].items()}
def signed(n): return (n&0x7fffffff)-(n&0x80000000)
def sat(n): return max(-2147483648,min(2147483647,n))

class Model:
    def __init__(self): self.reset()
    def reset(self):
        self.rf=[0]*256;self.pc=META['start'];self.stack=[];self.result=[0]*30
        self.inputs=None;self.instructions=0;self.waiting=False
        self.run()
    def run(self):
        for _ in range(50000):
            ins=ROM[self.pc];op=OPS[ins>>56];d=(ins>>48)&255;a=self.rf[(ins>>40)&255];b=self.rf[(ins>>32)&255];imm=signed(ins&0xffffffff)
            if op=='WAIT' and self.inputs is None: self.waiting=True;return
            self.pc+=1;self.instructions+=1
            if op=='MOV': self.rf[d]=a
            elif op=='LDI': self.rf[d]=imm
            elif op=='ADD': self.rf[d]=sat(a+b)
            elif op=='SUB': self.rf[d]=sat(a-b)
            elif op=='MUL': self.rf[d]=sat((a*b)>>imm)
            elif op=='DIV':
                q=(abs(a)<<(0 if imm==1 else 24))//abs(b) if b else (1<<64)-1
                self.rf[d]=sat(-q if (a<0)!=(b<0) else q)
            elif op=='SQRT': self.rf[d]=math.isqrt(max(0,a)<<24)
            elif op=='NEG': self.rf[d]=signed(-a)
            elif op=='ABS': self.rf[d]=signed(abs(a))
            elif op=='SHR': self.rf[d]=signed(a>>b if b>=0 else a<<(-b))
            elif op=='BAND': self.rf[d]=a&b
            elif op=='BOR': self.rf[d]=signed(a|b)
            elif op=='JMP': self.pc=imm
            elif op in ('EQ','NE','LT','LE','GT','GE'):
                if dict(EQ=a==b,NE=a!=b,LT=a<b,LE=a<=b,GT=a>b,GE=a>=b)[op]:self.pc=imm
            elif op=='CALL':self.stack.append(self.pc);self.pc=imm
            elif op=='RET':self.pc=self.stack.pop()
            elif op=='WAIT':self.waiting=False;self.active=self.inputs;self.inputs=None
            elif op=='IN':self.rf[d]=self.active[imm]
            elif op=='OUT':self.result[imm]=a
            elif op=='PUBLISH': self.inputs=None;self.run();return
            else:raise ValueError(op)
        raise RuntimeError('sequencer watchdog')
    def sample(self,a,b,c,seq,gap=0):
        s=lambda x: (x&32767)-(x&32768)
        self.inputs=[s(a>>16)<<10,s(a)<<10,s(b>>16)<<10,s(b),s(c>>16),s(c),seq,gap]
        self.run()
        # Invalid acceleration may reject a sample before PUBLISH.
        return self.result.copy()

if __name__=='__main__':
    m=Model()
    for i in range(101):r=m.sample(0,16384<<16,0,i&127)
    assert r[0]==0x17494d55 and r[1]&3==3,r
    assert max(abs(a-b) for a,b in zip(r[3:12],[4096,0,0,0,4096,0,0,0,4096]))<=2,r
    print('TEST_PASS Q24 attitude model stationary calibration',r[:13])
