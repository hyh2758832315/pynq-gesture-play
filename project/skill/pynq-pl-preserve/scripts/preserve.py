"""Build an all-output reference monitor around an unchanged existing RTL testbench.

Commands:
  python -X utf8 -B preserve.py build CONFIG.json --out NEW_DIRECTORY
  vivado -mode batch -source NEW_DIRECTORY/run.tcl
  python -X utf8 -B preserve.py verify NEW_DIRECTORY
Outputs: renamed frozen reference, wrapper, Vivado Tcl, hashes and actual verification receipt.
Next: inspect the coverage of the reused stimulus and add missing tests; this is
finite preservation checking, not formal equivalence or new-function validation.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import re

IDENT = r'[A-Za-z_][A-Za-z0-9_$]*'

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def require(ok, message):
    if not ok:
        raise ValueError(message)

def without_comments(text):
    return re.sub(r'/\*.*?\*/|//[^\n]*|\(\*.*?\*\)|"(?:[^"\\]|\\.)*"', lambda m: ''.join('\n' if c=='\n' else ' ' for c in m[0]), text, flags=re.S)

def require_leaf(source):
    # Conservative rejection of ordinary instance syntax, not an HDL elaborator.
    keywords=set(('module function task automatic integer int logic bit reg wire '
                  'signed unsigned input output parameter localparam if else for while '
                  'case casez casex return always always_ff always_comb initial final '
                  'begin end generate endgenerate assert assume cover property').split())
    instance=r'\b('+IDENT+r')(?:\s*#\s*\(.*?\)\s*|\s+)('+IDENT+r')\s*(?:\[[^]]+\]\s*)*\('
    for match in re.finditer(instance,without_comments(source),re.S):
        require(match[1] in keywords,'Only leaf DUTs are supported; possible child instance: '+match[1]+' '+match[2])

def require_isolated_units(source):
    clean=without_comments(source)
    for directive in re.findall(r'`('+IDENT+r')',clean):
        require(directive in {'timescale','default_nettype'},
                'Unsupported shared preprocessing dependency: `'+directive+'; provide self-contained source units')
    require(re.search(r'\b(?:import|export|bind)\b|::',clean) is None,
            'Unsupported package/import/bind dependency; source units must be self-contained')
    # This is a conservative supported-language guard, not a full SV parser.
    remaining=re.sub(r'\bmodule\b.*?\bendmodule\b(?:\s*:\s*'+IDENT+r')?', ' ',clean,flags=re.S)
    remaining=re.sub(r'(?m)^\s*`(?:timescale|default_nettype)[^\n]*(?:\n|$)',' ',remaining)
    require(not remaining.strip(' \t\r\n;'),
            'Unsupported compilation-unit declaration outside modules; do not share mutable reference context')

def require_self_contained_dut(source):
    require_isolated_units(source)
    clean=without_comments(source)
    require(re.search(r'\b(?:extern|force|release)\b',clean) is None,
            'Unsupported external/forced DUT state')
    require(re.search(r'\b'+IDENT+r'\s*(?:\[[^]]+\]\s*)?\.\s*'+IDENT,clean) is None,
            'Unsupported hierarchical/structured DUT dependency')
    require(re.search(r'\$(?:readmem[bh]|fopen|fclose|fread|fscanf|fgets|fgetc|system|random|urandom(?:_range)?|time|realtime|test\$plusargs|value\$plusargs)\b',clean) is None,
            'Unsupported file/environment/nondeterministic DUT dependency')
    require_leaf(source)

def group(text, start):
    require(text[start]=='(', 'Expected parenthesized module header')
    depth=0
    for end in range(start,len(text)):
        if text[end]=='(': depth+=1
        elif text[end]==')':
            depth-=1
            if depth==0: return text[start+1:end],end+1
    raise ValueError('Unterminated module header')

def split_fields(text):
    result=[];depth=0;start=0
    for i,c in enumerate(text):
        if c in '([': depth+=1
        elif c in ')]': depth-=1
        elif c==',' and depth==0:
            result.append(text[start:i].strip());start=i+1
    result.append(text[start:].strip())
    return [x for x in result if x]

def header(source):
    clean=without_comments(source)
    modules=list(re.finditer(r'\bmodule\s+('+IDENT+r')\b',clean))
    require(len(modules)==1,'Reference file must contain exactly one module; extract it explicitly first')
    match=modules[0]
    position=match.end()
    while clean[position].isspace(): position+=1
    parameters={}
    if clean[position]=='#':
        position+=1
        while clean[position].isspace(): position+=1
        body,position=group(clean,position)
        for field in split_fields(body):
            require(field.startswith('parameter '),'Each parameter must have an explicit parameter declaration')
            lhs,separator,_=field.partition('=')
            require(bool(separator),'Parameter default is required')
            named=re.search(r'('+IDENT+r')\s*$',lhs)
            require(named is not None,'Unsupported parameter declaration')
            name=named[1]
            kind=lhs[len('parameter'):named.start()].strip()
            require(re.fullmatch(r'(?:integer|int|logic|bit|signed|unsigned|\s|\[[A-Za-z0-9_$+*/():\s-]+\])*',kind) is not None,
                    'Only simple integral parameters are supported')
            require(name not in parameters,'Duplicate parameter')
            parameters[name]=kind
    while clean[position].isspace(): position+=1
    body,_=group(clean,position)
    ports=[]
    pattern=r'^(input|output)\s+(?:(?:wire|logic|reg)\s+)?(?:(signed|unsigned)\s+)?(\[[A-Za-z0-9_$+*/():\s-]+\]\s*)?('+IDENT+r')$'
    for field in split_fields(body):
        port=re.fullmatch(pattern,field.strip())
        require(port is not None,'Unsupported port; require explicit ANSI scalar/packed input/output: '+field)
        direction,signed,width,name=port.groups()
        ports.append({'direction':direction,'signed':signed or '', 'width':(width or '').strip(),'name':name})
    require(len({p['name'] for p in ports})==len(ports),'Duplicate port name')
    require(any(p['direction']=='input' for p in ports) and any(p['direction']=='output' for p in ports),'Need both input and output ports')
    renamed=source[:match.start(1)]+'pl_preserve_reference'+source[match.end(1):]
    return parameters,ports,renamed,match[1]

def literal(value):
    require(type(value) in (int,str),'Parameter values must be integer or integral SV literal')
    value=str(value)
    require(re.fullmatch(r"-?(?:[0-9]+|[0-9]+'[sS]?[bBoOdDhH][0-9a-fA-F_]+)",value) is not None,
            'Use explicit integral literal, not a parameter expression: '+value)
    return value

def tcl_path(path):
    value=path.resolve().as_posix()
    require(not any(c in value for c in '{}\n\r'),'Unsupported Tcl path characters')
    return '{'+value+'}'

def build(config_path,out):
    config_path=config_path.resolve(strict=True)
    config=json.loads(config_path.read_text(encoding='utf-8-sig'))
    allowed={'reference','sources','legacy_top','instances','clock','reset','reset_active','min_checks','watchdog_ns','legacy_marker','part'}
    require(set(config)==allowed,'Config must explicitly specify exactly: '+', '.join(sorted(allowed)))
    require(not out.exists(),'Use a fresh output directory to preserve previous attempts')
    root=config_path.parent
    reference=(root/config['reference']).resolve(strict=True)
    original=reference.read_text(encoding='utf-8-sig')
    require_self_contained_dut(original)
    parameters,ports,renamed,module_name=header(original)
    port_map={p['name']:p for p in ports}
    for key in ('clock','reset'):
        require(config[key] in port_map and port_map[config[key]]['direction']=='input' and not port_map[config[key]]['width'],
                key+' must name a scalar input')
    require(config['clock']!=config['reset'],'Clock and reset must differ')
    require(type(config['reset_active']) is int and config['reset_active'] in (0,1),'reset_active must be 0 or 1')
    for key in ('min_checks','watchdog_ns'):
        require(type(config[key]) is int and config[key]>0,key+' must be positive integer')
    require(re.fullmatch(IDENT,config['legacy_top']) is not None,'Invalid legacy top name')
    require(bool(config['legacy_marker']) and '\n' not in config['legacy_marker'],'Need one expected legacy terminal marker')
    require(re.fullmatch(r'[A-Za-z0-9_-]+',config['part']) is not None,'Invalid part')
    sources=[(root/p).resolve(strict=True) for p in config['sources']]
    require(sources and len(set(sources))==len(sources),'Need unique explicit source list')
    for path in sources:
        require(path.suffix in ('.v','.sv'),'Source list only supports Verilog/SystemVerilog files')
        require('pl_preserve_reference' not in without_comments(path.read_text(encoding='utf-8-sig')),'Reserved reference identifier in sources')
        require_isolated_units(path.read_text(encoding='utf-8-sig'))
    actual_definitions=[]
    for path in sources:
        source=path.read_text(encoding='utf-8-sig')
        if re.search(r'\bmodule\s+'+re.escape(module_name)+r'\b',without_comments(source)):
            actual_definitions.append((path,source))
    require(len(actual_definitions)==1,'Source list must define the actual DUT exactly once')
    actual_parameters,actual_ports,_,_=header(actual_definitions[0][1])
    require_self_contained_dut(actual_definitions[0][1])
    require(actual_parameters==parameters and actual_ports==ports,
            'Actual DUT interface differs from reference; strict preservation monitor cannot omit changed ports/parameters')
    instances=config['instances']
    require(isinstance(instances,list) and instances,'Need explicit DUT instance bindings')
    seen=set();lines=['`timescale 1ns/1ps','module tb_pl_preserve_generated;',config['legacy_top']+' legacy();']
    for number,instance in enumerate(instances):
        require(set(instance)=={'path','parameters'},'Each instance needs path and all parameter values')
        path=instance['path']
        require(re.fullmatch(IDENT+r'(?:\.'+IDENT+r')*',path) is not None and path not in seen,'Need unique simple hierarchy path')
        seen.add(path)
        require(set(instance['parameters'])==set(parameters),'Explicitly list every declared parameter for '+path)
        values={name:literal(instance['parameters'][name]) for name in parameters}
        # A scope gives width expressions the exact integral parameter types.
        lines+=['generate if (1) begin : monitor_'+str(number)]
        for name,kind in parameters.items(): lines+=['localparam '+kind+' '+name+' = '+values[name]+';']
        binds=[];outputs=[]
        for port in ports:
            name=port['name'];signal='legacy.'+path+'.'+name
            if port['direction']=='output':
                lines+=['wire '+port['signed']+' '+port['width']+' reference_'+name+';']
                binds+=['.'+name+'(reference_'+name+')'];outputs.append((name,signal))
            else: binds+=['.'+name+'('+signal+')']
        overrides=' #('+','.join('.'+name+'('+name+')' for name in parameters)+')' if parameters else ''
        lines+=['pl_preserve_reference'+overrides+' frozen('+','.join(binds)+');',
                'integer checks=0, reset_samples=0, active_samples=0; reg parameter_checked=0;',
                'initial begin #0.001;']
        for name in parameters:
            lines+=['if (legacy.'+path+'.'+name+' !== '+name+') $fatal(1,"PRESERVE_PARAMETER_MISMATCH '+str(number)+' '+name+'");']
        lines+=['parameter_checked=1; end','task automatic compare_outputs;', 'begin',
                'checks=checks+1;']
        for name,signal in outputs:
            lines+=['if ('+signal+' !== reference_'+name+') $fatal(1,"PRESERVE_OUTPUT_MISMATCH instance='+str(number)+' port='+name+' checks=%0d",checks);']
        lines+=['end endtask',
                'always @(posedge legacy.'+path+'.'+config['clock']+') begin #0.001;',
                'if (legacy.'+path+'.'+config['reset']+' === 1\'b'+str(config['reset_active'])+') reset_samples=reset_samples+1;',
                'if (legacy.'+path+'.'+config['reset']+' === 1\'b'+str(1-config['reset_active'])+') active_samples=active_samples+1;',
                'if (reset_samples>0) compare_outputs(); end',
                'always @(negedge legacy.'+path+'.'+config['clock']+') begin #0.001; if (reset_samples>0) compare_outputs(); end',
                'final begin',
                'if (!parameter_checked || checks<'+str(config['min_checks'])+' || reset_samples==0 || active_samples==0)',
                '$error("PRESERVE_INCOMPLETE instance='+str(number)+' checks=%0d reset=%0d active=%0d",checks,reset_samples,active_samples);',
                'else $display("PRESERVE_FINAL_PASS instance='+str(number)+' checks=%0d reset=%0d active=%0d",checks,reset_samples,active_samples);',
                'end','end endgenerate']
    lines+=['initial begin #'+str(config['watchdog_ns'])+'; $fatal(1,"PRESERVE_WATCHDOG"); end','endmodule']
    out.mkdir(parents=True)
    (out/'frozen_reference.sv').write_text(renamed,encoding='utf-8',newline='\n')
    (out/'monitor.sv').write_text('\n'.join(lines)+'\n',encoding='utf-8',newline='\n')
    out=out.resolve()
    tcl=f'''# Vivado: source {out.as_posix()}/run.tcl
# Outputs: isolated simulation project and raw logs; next use preserve.py verify.
set preserve_out {tcl_path(out)}
set preserve_project [file join $preserve_out simulation]
if {{[file exists $preserve_project]}} {{error {{Preserve earlier execution; build a fresh directory}}}}
create_project preservation $preserve_project -part {config['part']}
add_files [list {' '.join(tcl_path(p) for p in sources)}]
add_files -fileset sim_1 [list {tcl_path(out/'frozen_reference.sv')} {tcl_path(out/'monitor.sv')}]
set_property top tb_pl_preserve_generated [get_filesets sim_1]
set_property target_simulator XSim [current_project]
set_property xsim.simulate.runtime all [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral
close_sim
close_project
'''
    (out/'run.tcl').write_text(tcl,encoding='utf-8',newline='\n')
    manifest={'scope':'Finite strict all-output preservation under existing stimulus only; not correctness, formal equivalence or board signoff',
              'reference_path':str(reference),'reference_sha256':digest(reference),'config':config,
              'config_path':str(config_path),'config_sha256':digest(config_path),
              'sources':{str(p):digest(p) for p in sources},'ports':ports,'parameter_names':list(parameters),
              'actual_dut_interface_checked':True,'actual_dut_source':str(actual_definitions[0][0]),
              'self_contained_source_units_required':True,
              'generated':{name:digest(out/name) for name in ('frozen_reference.sv','monitor.sv','run.tcl')}}
    (out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'built':str(out),'instances':len(instances),'compared_outputs_each':len(outputs),'executed':False}))

def verify(out):
    manifest=json.loads((out/'manifest.json').read_text())
    require(digest(Path(manifest['reference_path']))==manifest['reference_sha256'],'Reference changed after build')
    require(digest(Path(manifest['config_path']))==manifest['config_sha256'],'Config changed after build')
    for name,expected in manifest['sources'].items(): require(digest(Path(name))==expected,'Source changed after build: '+name)
    for name,expected in manifest['generated'].items(): require(digest(out/name)==expected,'Generated input changed: '+name)
    path=out/'simulation/preservation.sim/sim_1/behav/xsim/simulate.log'
    body=path.read_text(encoding='utf-8',errors='replace')
    require(re.search(r'\b(?:fatal|error)\s*:',body,re.I) is None,'Runtime error/fatal in actual transcript')
    require('PRESERVE_OUTPUT_MISMATCH' not in body and 'PRESERVE_PARAMETER_MISMATCH' not in body and 'PRESERVE_INCOMPLETE' not in body and 'PRESERVE_WATCHDOG' not in body,'Preservation failed or incomplete')
    require(manifest['config']['legacy_marker'] in body,'Original test terminal marker missing')
    require('$finish called' in body,'Missing actual testbench finish')
    rows=re.findall(r'^PRESERVE_FINAL_PASS instance=(\d+) checks=(\d+) reset=(\d+) active=(\d+)\s*$',body,re.M)
    require(len(rows)==len(manifest['config']['instances']),'Missing/duplicate monitor terminal result')
    require({int(row[0]) for row in rows}==set(range(len(rows))),'Missing instance terminal result')
    require(all(int(row[1])>=manifest['config']['min_checks'] and int(row[2])>0 and int(row[3])>0 for row in rows),'Insufficient actual monitor coverage')
    receipt={'status':'PRESERVATION_UNDER_SUPPLIED_STIMULUS_PASS','manifest_sha256':digest(out/'manifest.json'),
             'transcript_sha256':digest(path),'instances':rows,'scope':manifest['scope']}
    with (out/'verified.json').open('x',encoding='utf-8') as handle: json.dump(receipt,handle,indent=2)
    print(json.dumps(receipt))

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    sub=parser.add_subparsers(dest='command',required=True)
    p=sub.add_parser('build');p.add_argument('config',type=Path);p.add_argument('--out',type=Path,required=True)
    p=sub.add_parser('verify');p.add_argument('out',type=Path)
    args=parser.parse_args()
    if args.command=='build': build(args.config,args.out)
    else: verify(args.out)

if __name__=='__main__':
    main()
