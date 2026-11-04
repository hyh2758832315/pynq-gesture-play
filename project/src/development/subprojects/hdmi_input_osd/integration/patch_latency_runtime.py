"""Apply reviewed C0E-only changes to the protected frozen-R1 restore.

Run: .venv/Scripts/python.exe -B .../patch_latency_runtime.py
Output: source delta receipt; no final manifest, package, or board access.
Next: numeric/contract tests and same-design C0E artifact pairing.
"""
import ast
import hashlib
import json
from pathlib import Path

from stage_latency_runtime import HERE,TARGET


def main():
    marker=json.loads((TARGET/'candidate_stage.json').read_text())
    assert marker['stage']=='SOURCE_ONLY_HARDWARE_PENDING'
    if (HERE/'evidence/latency-runtime-patch-r01.json').exists(): raise FileExistsError('already patched')
    changes={}
    def write(path,original,modified):
        if original!=modified:
            ast.parse(modified,feature_version=(3,10))
            path.write_text(modified,encoding='utf-8')
            changes[path.relative_to(TARGET).as_posix()]=dict(
                before=hashlib.sha256(original.encode()).hexdigest(),
                after=hashlib.sha256(modified.encode()).hexdigest())
    # This is a paired C0E client/runtime, not an edit to R1 or the main worktree.
    for directory in ('python/pynq_multimodal_game','board/pynq_z2/scripts','tools'):
        for path in (TARGET/directory).rglob('*.py'):
            original=path.read_text(encoding='utf-8')
            modified=original.replace('C0060D00','C0060E00').replace(
                'C6I_VISION_VOLUME_V1','C6I_PL_VISION_VOLUME_OSD_V1')
            write(path,original,modified)
    path=TARGET/'python/pynq_multimodal_game/agent/cli.py'
    original=path.read_text(encoding='utf-8')
    anchor='        from pynq.lib.video import VideoMode\n'
    assert original.count(anchor)==1
    replacement='''        if fusion_volume:
            from .pl_volume_factory import create_worker as create_pl_worker
            return create_pl_worker(session, provider, osd_hub, args, run_id, runtime, camera, AxiIIC)
'''+anchor
    write(path,original,original.replace(anchor,replacement))
    path=TARGET/'board/pynq_z2/scripts/vision_async_runtime.py'
    original=path.read_text(encoding='utf-8')
    begin=original.index('class SharedDualMaskHardware:')
    end=original.index('\ndef lower_vision_worker_cpu_priority',begin)
    block=original[begin:end]
    assert block.count('0xC0060B00')==2 and block.count('BUILD0B00')==1
    block=block.replace('0xC0060B00','0xC0060E00').replace('BUILD0B00','BUILD0E00').replace(
        "profile = 'C6I_PL_DUAL_MASK'","profile = 'C6I_PL_VISION_VOLUME_OSD_V1'")
    write(path,original,original[:begin]+block+original[end:])
    path=TARGET/'board/pynq_z2/scripts/verify_vision_integration_sources.py'
    original=path.read_text(encoding='utf-8')
    old='    if modules["skin_kernel"].get("MODTYPE") != "bgr_skin_dma":\n'
    assert original.count(old)==1
    modified=original.replace(old,'    if build_id != 0xC0060E00 and modules["skin_kernel"].get("MODTYPE") != "bgr_skin_dma":\n')
    anchor='    control_ranges = sorted('
    location=modified.index(anchor)
    extra='''    if build_id == 0xC0060E00:
        if "skin_kernel" in modules:
            raise ValueError("C0E replaces SKN6; old kernel must be absent")
        for name,base,kind in (("capture_control",0x413F0000,"axi_vision_capture_control"),
                               ("capture_status",0x41410000,"axi_vision_capture_status")):
            if ranges.get(name)!=(base,base+0xFFFF) or modules[name].get("MODTYPE")!=kind:
                raise ValueError("C0E capture control/status identity mismatch: "+name)
        if modules["dual_mask_capture"].get("MODTYPE")!="axis_rgb_capture_bd":
            raise ValueError("C0E dual-mask capture module mismatch")
'''
    modified=modified[:location]+extra+modified[location:]
    assert modified.count('"vision_control_smc": {"NUM_MI": "6"}')==1
    modified=modified.replace('"vision_control_smc": {"NUM_MI": "6"}',
        '"vision_control_smc": {"NUM_MI": "8"},\n            "capture_control": {"OWNER_PROTOCOL": "1"},\n            "dual_mask_capture": {"INPUT_WIDTH": "1280", "INPUT_HEIGHT": "720", "CONTINUOUS": "1", "SEQUENCE_FRAME_IDS": "1", "USE_FRAME_CREDITS": "1"}')
    anchor='        for channel in ("AW", "AR", "W", "R", "B"):\n'
    assert modified.count(anchor)==1
    checks='''        from vision_async_runtime import SharedDualMaskHardware
        for instance,required in SharedDualMaskHardware.DMA_PARAMETERS.items():
            actual=parameters(instance)
            if any(int(str(actual.get(key,"-1")),0)!=value for key,value in required.items()):
                raise ValueError("C0E DMA capability mismatch: "+instance)
'''
    # Avoid importing cv2/PYNQ merely to check HWH: emit this fixed contract as data.
    checks=checks.replace('        from vision_async_runtime import SharedDualMaskHardware\n','').replace(
        'SharedDualMaskHardware.DMA_PARAMETERS.items()',
        '''{"frame_dma":{"C_INCLUDE_MM2S":0,"C_INCLUDE_S2MM":1,"C_INCLUDE_SG":0,"C_NUM_FSTORES":3,"C_M_AXI_S2MM_DATA_WIDTH":64,"C_S_AXIS_S2MM_TDATA_WIDTH":24,"C_INCLUDE_S2MM_DRE":0,"C_INCLUDE_S2MM_SF":1,"C_USE_FSYNC":1},"moments_dma":{"C_INCLUDE_MM2S":0,"C_INCLUDE_S2MM":1,"C_INCLUDE_SG":1,"C_M_AXI_S2MM_DATA_WIDTH":64,"C_S_AXIS_S2MM_TDATA_WIDTH":64,"C_M_AXI_SG_DATA_WIDTH":32,"C_INCLUDE_S2MM_DRE":0,"C_INCLUDE_S2MM_SF":1}}.items()''')
    modified=modified.replace(anchor,checks+anchor)
    write(path,original,modified)
    with (HERE/'evidence/latency-runtime-patch-r01.json').open('x',encoding='utf-8') as stream:
        json.dump(dict(status='SOURCE_PATCHED_NOT_DEPLOYABLE',changes=changes,board_operations=False,
                       release_ready=False,hardware_pending=True),stream,indent=2)
    print('C0E_SOURCE_PATCHED_PY310_AST',len(changes))


if __name__=='__main__': main()
