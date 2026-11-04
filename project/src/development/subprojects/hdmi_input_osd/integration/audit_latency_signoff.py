"""C0E scoped hardware audit. No board access and no waiver.
Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/audit_latency_signoff.py
Output: exclusive evidence/latency-signoff-r05.json. Next: pair/export exact reviewed DCP, ARM/board gates.
"""
import argparse,hashlib,json,re
from pathlib import Path
from audit_latency_timing import active_xdc

REPO=Path(__file__).resolve().parents[3]
HERE=Path(__file__).resolve().parent
ROOT=REPO/'build/hosd/c0e/postroute-r05'
REPORT=ROOT/'signoff'
EXT=ROOT/'extended'
def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p): return p.read_text(encoding='utf-8')
def rules(t):
    return {m[0]:(m[1],int(m[2])) for m in re.findall(r'^\|\s*([A-Z][A-Z0-9]*-\d+)\s*\|\s*(Warning|Advisory|Critical Warning|Error)\s*\|[^\n]*\|\s*(\d+)\s*\|',t,re.M)}
def resource(label):
    return float(re.search(r'^\|\s*'+re.escape(label)+r'\s*\|\s*([\d.]+)\s*\|',read(REPORT/'utilization.rpt'),re.M)[1])

def review_xdc():
    baseline=active_xdc(REPO/'build/hosd/c0e/preroute-r04/results/constraints_before.xdc')
    actual=active_xdc(REPORT/'effective_timing.xdc')
    if actual==baseline:
        return dict(kind='LITERAL_EXACT_EQUAL')
    # Physical driver replication can change get_ports serialization. Never ignore
    # the difference: require exact six scopes and live one-object equivalence,
    # tied to this specific final DCP. All other statements remain byte-identical.
    assert len(actual)==len(baseline)
    allowed={'c6v_i/capture_lifecycle/inst/'+name for name in (
        'fence/source_reset','admission/source_reset','budget/video_reset',
        'budget/processing_reset','fence/monitor/video_reset','fence/monitor/processing_reset')}
    changed=[]
    original='set_false_path -through [get_ports -scoped_to_current_instance -no_traverse src_arst]'
    replacement='set_false_path -through [get_ports -scoped_to_current_instance src_arst]'
    for index,(old,new) in enumerate(zip(baseline,actual)):
        if old==new:continue
        assert old==original and new==replacement and index>0
        assert baseline[index-1]==actual[index-1] and baseline[index-1].startswith('current_instance ')
        scope=baseline[index-1].removeprefix('current_instance ')
        assert scope in allowed
        changed.append(scope)
    assert len(changed)==6 and set(changed)==allowed
    evidence=EXT/'reset_scope_aliases.tcldict'
    text=read(evidence)
    assert re.search(r'candidate_sha256 ([0-9a-f]{64})',text)[1]==digest(REPORT/'candidate.dcp')
    assert text.count('{scope ')==6
    for scope in allowed:
        expected='{scope '+scope+' no_traverse '+scope+'/src_arst normal '+scope+'/src_arst equal 1}'
        assert text.count(expected)==1
    return dict(kind='SIX_PROVEN_IDENTICAL_RESET_PORT_SELECTORS',scopes=sorted(changed),proof_sha256=digest(evidence))
def main():
    global ROOT,REPORT,EXT
    parser=argparse.ArgumentParser()
    parser.add_argument('--root',type=Path,default=ROOT)
    parser.add_argument('--numeric',type=Path,default=REPO/'build/hosd/c0e-n02/receipt.json')
    parser.add_argument('--receipt',type=Path,default=HERE/'evidence/latency-signoff-r05.json')
    args=parser.parse_args()
    ROOT=args.root.resolve();REPORT=ROOT/'signoff';EXT=ROOT/'extended'
    receipt=args.receipt.resolve()
    assert ROOT.is_relative_to(REPO/'build/hosd') and receipt.is_relative_to(HERE/'evidence')
    if receipt.exists(): raise FileExistsError(receipt)
    record=dict(status='RUNNING',board_validated=False,release_ready=False,warnings_waived=False)
    try:
        timing=read(REPORT/'timing.rpt')
        summary=timing.split('| Design Timing Summary',1)[1]
        row=re.search(r'WNS\(ns\).*?\n\s*-+.*?\n([^\n]+)',summary,re.S)[1].split()
        assert len(row)==12 and all(float(row[i])>=0 for i in (0,4,8))
        assert all(float(row[i])==0 for i in (1,2,5,6,9,10))
        assert 'All user specified timing constraints are met.' in summary
        for check in ('no_clock','unconstrained_internal_endpoints','multiple_clock','loops'):
            assert 'checking '+check+' (0)' in timing
        record['timing']=dict(wns_ns=float(row[0]),tns_ns=float(row[1]),setup_failing_endpoints=int(row[2]),
                             whs_ns=float(row[4]),ths_ns=float(row[5]),wpws_ns=float(row[8]))
        route=read(REPORT/'route.rpt')
        r=[int(re.search(r'# of '+label+r'\.+\s*:\s*(\d+)\b',route)[1]) for label in
           ('routable nets','fully routed nets','nets with routing errors')]
        assert r[0]==r[1]>0 and r[2]==0
        record['route']=dict(routable=r[0],fully_routed=r[1],errors=r[2])
        record['effective_constraint_review']=review_xdc()
        xdc=read(REPORT/'effective_timing.xdc')
        assert 'set_clock_groups' not in xdc
        assert 'create_clock -period 10.000 -name clk_fpga_0' in xdc
        assert 'budget/held_budget_reg[*]/C' in xdc and 'budget/budget_meta_reg[*]/D' in xdc
        assert xdc.count('set_bus_skew ')==4
        record['constraints_unchanged']=True
        drc=rules(read(EXT/'drc_unlimited.rpt'))
        expected={'DPIP-1':17,'DPOP-1':9,'DPOP-2':16,'DPOR-1':17,'PLBUFGOPT-1':1,'PLCK-12':1,
                  'REQP-1839':72,'REQP-1840':48,'RTSTAT-10':1,'REQP-165':4,'REQP-181':4}
        assert {k:v[1] for k,v in drc.items()}==expected
        assert not any(v[0] in ('Critical Warning','Error') for v in drc.values())
        assert 'CHECK-3' not in drc
        method=rules(read(REPORT/'methodology.rpt'))
        assert {k:v[1] for k,v in method.items()}=={'DPIR-1':128,'PDRC-190':32,'TIMING-18':4,'ULMTCS-2':1,'XDCB-5':1}
        assert not any(v[0] in ('Critical Warning','Error') for v in method.values())
        record.update(drc_unlimited=drc,methodology=method)
        cdc=read(REPORT/'cdc.rpt')
        assert not re.search(r'^CDC-\d+\s+Critical',cdc,re.M)
        allcdc=read(EXT/'cdc_all.rpt')
        assert not re.search(r'^CDC-\d+\s+Critical',allcdc,re.M)
        assert re.search(r'^CDC-6\s+Warning\s+1\s',cdc,re.M)
        assert re.search(r'^CDC-15\s+Warning\s+135\s',cdc,re.M)
        payload=[line for line in cdc.splitlines() if 'CDC-15' in line and 'mailbox_reg[' in line]
        assert len(payload)==135
        indices=[]
        for line in payload:
            a,b=re.search(r'mailbox_reg\[(\d+)\].*pending_cfg_reg\[(\d+)\]',line).groups()
            assert a==b and 'Max Delay Datapath Only' in line
            indices.append(int(a))
        assert len(set(indices))==135
        budget=[line for line in cdc.splitlines() if 'CDC-6' in line and 'held_budget_reg[95:0]' in line]
        assert len(budget)==1 and 'Max Delay Datapath Only' in budget[0]
        skew=read(REPORT/'bus_skew.rpt')
        assert 'VIOLATED' not in skew
        assert re.findall(r'^Endpoints: (\d+)',skew,re.M)==['96','10','10','135']
        slacks=list(map(float,re.findall(r'^Slack \(MET\)\s*:\s*([\d.]+)ns',skew,re.M)))
        assert len(slacks)==4 and min(slacks)>0
        record['cdc_review']=dict(osd_bits=135,budget_bits=96,no_critical=True,bus_skew_slacks_ns=slacks,
             scope='Stable bundled payload and req/reply handshake reviewed in METHODOLOGY_RESOLUTION_REPORT.md; warnings retained, not waived.')
        clocklines=read(EXT/'design_identity.tcldict').splitlines()
        assert len(clocklines)>33
        assert all(line.endswith('clocks clk_fpga_0') for line in clocklines[1:])
        record['same_clock_dma_sync_chain']=True
        numeric=json.loads(read(args.numeric))
        assert numeric['status']=='BGR_FRONTEND_AND_CAPTURE_NUMERIC_PASS'
        sources=[Path(line) for line in read(EXT/'project_synthesis_files.txt').splitlines() if line]
        byname={}
        for p in sources: byname.setdefault(p.name,[]).append(p)
        matched={}
        for name,sha in numeric['source_sha256'].items():
            if name.startswith('tb_') or name not in byname: continue
            assert all(digest(p)==sha for p in byname[name]),name
            matched[name]=sha
        assert all(name in matched for name in ('axis_binary_dilate9.sv','axis_rgb_mask_frontend.sv','axis_bgr_hsv_skin.sv','vision_source_budget_cdc.sv','vision_frame_owner.sv','vision_capture_lifecycle.sv'))
        record['numeric_production_sources']=matched
        record['synthesis_sources']={str(p):digest(p) for p in sources if p.is_file()}
        record['resources']={k:resource(k) for k in ('Slice LUTs','Slice Registers','Slice','Block RAM Tile','DSPs')}
        assert record['resources']['Slice']<=13300 and record['resources']['Block RAM Tile']<=140
        record['review_sha256']=digest(REPORT/'METHODOLOGY_RESOLUTION_REPORT.md')
        record['files']={str(p.relative_to(ROOT)):digest(p) for folder in (REPORT,EXT)
                         for p in sorted(folder.iterdir()) if p.is_file()}
        record['status']='C0E_TIMING_ROUTE_AND_SCOPED_REVIEW_PASS'
        record['limits']=[f"Setup margin {record['timing']['wns_ns']:.3f}ns; unchanged100MHz constraint",
            f"Slice {record['resources']['Slice']/13300*100:.2f}%; not a broad resource scalability claim",
            '96-bit CDC-6 and135-bit CDC-15 warnings retained with bounded handshake review',
            'Async reset RAM/DSP warnings reviewed only for epoch discard/reinitialization contract; not universal reset immunity',
            'Inherited camera PCLK route override and I2C delays retained; no general IO signoff',
            'Physical board/real inputs/performance and full release remain pending']
    except BaseException as error:
        record.update(status='FAIL',error=f'{type(error).__name__}: {error}')
        raise
    finally:
        with receipt.open('x',encoding='utf-8') as f: json.dump(record,f,indent=2)
    print(record['status'],record['timing'],record['resources'])
if __name__=='__main__': main()

