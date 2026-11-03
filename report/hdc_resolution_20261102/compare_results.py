"""Compare the matched routed baseline and final routed candidate."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parent

def resources(path):
    text = path.read_text()
    keys = {'lut':'Slice LUTs','ff':'Slice Registers','slice':'Slice',
            'bram36':'Block RAM Tile','dsp':'DSPs'}
    return {key:float(re.search(r'^\| '+re.escape(label)+r'\s+\|\s*([0-9.]+)',text,re.M)[1])
            for key,label in keys.items()}

def timing(path):
    text = path.read_text()
    match = re.search(r'WNS\(ns\).*?\n\s*-+.*?\n\s*([-\d.]+)\s+([-\d.]+)\s+(\d+)\s+\d+\s+([-\d.]+)',text,re.S)
    return dict(wns_ns=float(match[1]),tns_ns=float(match[2]),failing_endpoints=int(match[3]),whs_ns=float(match[4]))

def main():
    baseline=resources(ROOT/'baseline/utilization_routed.rpt')
    candidate=resources(ROOT/'utilization_routed.rpt')
    old_timing=timing(ROOT/'baseline/timing_routed.rpt')
    new_timing=timing(ROOT/'timing_routed.rpt')
    result={'stage':'Routed','device':'xc7z020clg400-2','tool':'Vivado 2025.2',
        'behavior_change':'Q16 to Q32 plus exact legacy Q16 and 0.01% score gap; not an equivalent-resource optimization',
        'baseline':baseline|old_timing,'candidate':candidate|new_timing,
        'resource_delta':{k:candidate[k]-baseline[k] for k in baseline},
        'resource_delta_percent':{k:100*(candidate[k]-baseline[k])/baseline[k] for k in baseline},
        'rtl_cycles_max_100mhz_variable_axi':{'nmf':3958,'scale':782,'q16_train':23863,
            'q32_train':23863,'q16_six_class_predict':77263,'q32_six_class_predict':77263},
        'board_performance_measured':False}
    (ROOT/'comparison.json').write_text(json.dumps(result,indent=2))
    print(json.dumps(result,indent=2))
    assert new_timing['wns_ns']>=0 and new_timing['whs_ns']>=0

if __name__=='__main__':main()
