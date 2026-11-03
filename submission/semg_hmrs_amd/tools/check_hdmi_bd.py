"""Verify an additive HDMI extension preserves the existing system wiring."""
import argparse
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
BD=ROOT/'build/vivado/hand_motion_reconstruction.srcs/sources_1/bd/design_1/design_1.bd'

def contract(design):
    return {
        'ports':{k:{p:v for p,v in d.items() if p in ('direction','type','left','right')}
                 for k,d in design['ports'].items()},
        'components':{k:{'vlnv':d['vlnv'],'parameters':{
            p:v['value'] for p,v in d.get('parameters',{}).items()}}
            for k,d in design['components'].items()},
        'nets':{k:sorted(d['ports']) for k,d in design['nets'].items()},
        'interface_nets':{k:sorted(d['interface_ports']) for k,d in design['interface_nets'].items()},
        'addressing':design['addressing']}

def verify(path):
    old=json.loads(path.read_text(encoding='utf-8'))
    design=json.loads(BD.read_text(encoding='utf-8'))['design'];new=contract(design)
    for name,p in old['ports'].items():
        assert new['ports'][name]==p,'Original external port changed: '+name
    allowed={('smartconnect_0','NUM_MI'),('smartconnect_1','NUM_SI')}
    for name,c in old['components'].items():
        assert new['components'][name]['vlnv']==c['vlnv'],'Original module replaced: '+name
        for p,value in c['parameters'].items():
            if (name,p) not in allowed:
                assert new['components'][name]['parameters'].get(p)==value,'Original IP configuration changed: '+name+'/'+p
    for kind in ('nets','interface_nets'):
        for name,endpoints in old[kind].items():
            assert set(endpoints)<=set(new[kind][name]),'Original connection removed: '+name
    for name,address in old['addressing'].items():
        for space,d in address.get('address_spaces',{}).items():
            for segment,value in d.get('segments',{}).items():
                assert new['addressing'][name]['address_spaces'][space]['segments'][segment]==value,'Original address changed: '+segment
    # Older BD stores only explicitly overridden parameters; the new clone
    # also serializes vendor defaults. Compare all original explicit values.
    for p,value in new['components']['axi_vdma_0']['parameters'].items():
        assert new['components']['axi_vdma_hdmi']['parameters'].get(p)==value,'HDMI DMA parameter changed: '+p
    for endpoints in (
        ['hdmi_output_0/stream_resetn','video_out_hdmi/aresetn'],
        ['gpio_hdmi/gpio2_io_o','hdmi_output_0/run','hdmi_scaler_0/run'],
        ['hdmi_output_0/pixel_clk','video_out_hdmi/vid_io_out_clk'],
        ['hdmi_output_0/video_rst','video_out_hdmi/vid_io_out_reset'],
        ['video_out_hdmi/vtg_ce','hdmi_output_0/vtg_ce']):
        assert any(set(endpoints)<=set(n) for n in new['nets'].values()),'Incomplete HDMI clock/reset/run handshake: '+str(endpoints)
    print(f'TEST_PASS HDMI BD: {len(old["components"])} inherited modules, {len(old["nets"])} original nets, addresses/ports unchanged, dual-domain restart contract')

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--baseline',type=Path,default=ROOT/'report/hdmi_mirror_20261103/baseline_bd_contract.json')
    ap.add_argument('--capture',type=Path)
    args=ap.parse_args()
    if args.capture:
        args.baseline.write_text(json.dumps(contract(json.loads(args.capture.read_text())['design']),indent=2),encoding='utf-8')
    verify(args.baseline)

