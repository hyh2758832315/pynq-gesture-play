"""Install reviewed hardware, freeze child manifest, restore and preflight ZIP.

Run with project venv: .venv/Scripts/python.exe -B .../finalize_child.py
Outputs: child ZIP, independent restore, evidence/g14-pair.json,g15-package.json.
Next: board_deploy.py stage; no board access occurs here.
"""
import ast
import hashlib
import json
import os
from pathlib import Path
import runpy
import subprocess
import sys
import zipfile

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
CHILD = REPO / "deliveries/c6i-vision-volume-osd-r16-20261022"
REPORT = REPO / "build/hosd/c0d/signoff-r02"


def digest(data): return hashlib.sha256(data).hexdigest()
def load(path): return json.loads(path.read_text(encoding="utf-8"))
def save(path, value):
    with path.open("x", encoding="utf-8") as stream: json.dump(value,stream,indent=2)


def main():
    receipt = HERE / "evidence/g15-package.json"
    archive_path = CHILD.with_suffix(".zip")
    restored = HERE / "evidence/g15-restored"
    if receipt.exists() or archive_path.exists() or restored.exists():
        raise FileExistsError("preserve previous finalization")
    signoff = load(HERE / "evidence/g13-signoff.json")
    assert signoff["status"] == "FULL_IMPLEMENTATION_TIMING_AND_SCOPED_REVIEW_PASS"
    for name, sha in signoff["files"].items(): assert digest((REPORT/name).read_bytes()) == sha
    games = load(HERE / "evidence/g09-games-r03.json")
    assert games["status"] == "DOUBLE_BUILD_PC_AND_R15_FRAME_EQUIVALENCE_PASS"
    verifier = runpy.run_path(str(CHILD / "board/pynq_z2/scripts/verify_vision_integration_sources.py"))
    for name in verifier["CANDIDATE_FILES"]:
        (CHILD / "overlay" / name).write_bytes((REPORT/name).read_bytes())
    paired = verifier["verify_volume_candidate_bundle"](CHILD / "overlay")
    (CHILD / "overlay/board_test_manifest.json").write_text(json.dumps(paired,indent=2)+"\n",encoding="utf-8")
    save(HERE / "evidence/g14-pair.json", paired)
    (CHILD / "overlay/osd_signoff_review.json").write_text(json.dumps(signoff,indent=2),encoding="utf-8")
    (CHILD / "overlay/METHODOLOGY_RESOLUTION_REPORT.md").write_bytes((REPORT/"METHODOLOGY_RESOLUTION_REPORT.md").read_bytes())
    (CHILD / "tools/osd_runtime_contract.py").write_bytes((HERE/"test_runtime_osd.py").read_bytes())
    (CHILD / "docs/hdmi_osd_integration.md").write_bytes((REPO/"docs/bringup/2026-10-22_pynq-z2_hdmi_input_osd_integration.md").read_bytes())
    # Frozen hardware source evidence lives with the candidate, independent of
    # future changes to the prototype or root working tree.
    for path in (REPO/"subprojects/hdmi_input_osd/rtl").glob("*.sv"):
        target=CHILD/"overlay/osd-source"/path.name
        target.parent.mkdir(exist_ok=True)
        target.write_bytes(path.read_bytes())
    (CHILD/"overlay/osd-source/osd_cdc.tcl").write_bytes((REPO/"subprojects/hdmi_input_osd/constraints/osd_cdc.tcl").read_bytes())
    manifest = load(CHILD / "deployment_manifest.json")
    parent_digest="a9bf7cc1d2f4420867e47e176f9be789966ef302d9a16c46cfabaa3cab945dfe"
    assert digest((REPO/"deliveries/c6i-vision-volume-c0c-r15-unified-input-20261022-r2.zip").read_bytes())==parent_digest
    contents={}
    for path in CHILD.rglob("*"):
        if not path.is_file(): continue
        name=path.relative_to(CHILD).as_posix()
        if name == "deployment_manifest.json" or "__pycache__" in path.parts: continue
        if name.startswith(("var/", "games/osd-c0d/", "games/osd-c0d-r02/")): continue
        data=path.read_bytes()
        if name.endswith(".py"): ast.parse(data.decode("utf-8-sig"),filename=name,feature_version=(3,10))
        contents[name]=data
    actual_packages={name:games["packages"][name]["sha256"] for name in games["packages"]}
    manifest.update(build_id="0xC0060D00",purpose="independent-hdmi-input-osd-c0d",
        parent_archive_sha256=parent_digest,board_pending=True,release_ready=False,
        osd_game_directory="games/osd-c0d-r03",osd_schema="hdmi-input-osd-v1",
        osd_always_on=True,osd_default_vision_start=True,
        games_sha256=actual_packages,game_sha256=actual_packages["game1-C0060D00.vvg"],
        sha256={name:digest(data).upper() for name,data in contents.items()})
    manifest_bytes=(json.dumps(manifest,indent=2)+"\n").encode("utf-8")
    (CHILD/"deployment_manifest.json").write_bytes(manifest_bytes)
    contents["deployment_manifest.json"]=manifest_bytes
    original=load(HERE/"evidence/g05-runtime-patch.json")
    delta={name:dict(initial=info["after"],final=digest((CHILD/name).read_bytes()))
           for name,info in original["changes"].items()}
    save(HERE/"evidence/g14-final-source-delta.json",dict(status="FINAL_SHA_AST_PASS",changes=delta))
    with zipfile.ZipFile(archive_path,"x",compression=zipfile.ZIP_DEFLATED) as archive:
        for name,data in sorted(contents.items()): archive.writestr(CHILD.name+"/"+name,data)
    restored.mkdir()
    with zipfile.ZipFile(archive_path) as archive:
        assert archive.testzip() is None
        assert len(archive.namelist())==len(contents)
        for name,data in contents.items():
            assert archive.read(CHILD.name+"/"+name)==data
            path=restored/name
            path.parent.mkdir(parents=True,exist_ok=True)
            with path.open("xb") as stream: stream.write(data)
    record=dict(status="RUNNING",sha256=digest(archive_path.read_bytes()),bytes=archive_path.stat().st_size,
                files=len(contents)-1,board_access=False,preflights=[])
    try:
        for root in (CHILD,restored):
            env={**os.environ,"PYTHONPATH":str(root/"python"),"PYTHONIOENCODING":"utf-8"}
            for extra in ([],["--volume-disable-sampling"]):
                command=[sys.executable,"-B",str(root/"start_board_test.py"),"--check-only","--game-controls",*extra]
                result=subprocess.run(command,cwd=root,env=env,text=True,encoding="utf-8",errors="replace",capture_output=True,timeout=90)
                record["preflights"].append(dict(command=command,returncode=result.returncode,stdout=result.stdout,stderr=result.stderr))
                assert result.returncode==0,result.stdout+result.stderr
            assert not (root/"var").exists()
            for name,sha in manifest["sha256"].items(): assert digest((root/name).read_bytes()).upper()==sha
        record["status"]="PACKAGE_RESTORED_AND_PREFLIGHT_PASS"
    except BaseException as error:
        record.update(status="FAIL",error=f"{type(error).__name__}: {error}")
        raise
    finally: save(receipt,record)
    print(record["status"],record["sha256"],record["files"])


if __name__=="__main__": main()
