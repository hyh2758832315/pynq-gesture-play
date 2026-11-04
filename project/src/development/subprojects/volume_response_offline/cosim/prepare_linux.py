"""Configure an isolated Zynq QEMU Linux/initramfs baseline with original Python.

PowerShell:
  wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/prepare_linux.py --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-linux-prepare-r01
Outputs: fixed config/DTS/kernel fragment/rootfs overlay and receipt.json.
Next: build_linux.py against the recorded Buildroot output, then boot only QEMU.
This representative Linux baseline is not a copy of the physical PYNQ image.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess

ROOT=Path(__file__).resolve().parents[3]
PACKAGE=ROOT/'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--linux-root',type=Path,default=Path('/root/voice-view-audio-cosim-r01'))
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    record=dict(status='RUNNING',board_access=False,production_pynq_image=False)
    config_root=a.linux_root/'linux-config-r01';build=a.linux_root/'buildroot-output-r01'
    try:
        for name,expected in [('buildroot','4f924fd52841608d68ac3dcb83fccee8b8c90316'),
                              ('qemu-devicetrees','f5fc4213431edb730a8b808119c693f34d863822')]:
            actual=subprocess.check_output(['git','-C',str(a.linux_root/name),'rev-parse','HEAD'],text=True).strip()
            assert actual==expected,(name,actual)
            record[name+'_commit']=actual
        config_root.mkdir(exist_ok=False);build.mkdir(exist_ok=False)
        dts=config_root/'dts/xilinx';dts.mkdir(parents=True)
        shutil.copyfile(a.linux_root/'qemu-devicetrees/zynq-pl-remoteport.dtsi',dts/'zynq-pl-remoteport.dtsi')
        (dts/'voice-view-cosim.dts').write_text('''#include "zynq-zc702.dts"
#include "zynq-pl-remoteport.dtsi"
/ {
    model = "VoiceView offline QEMU cosimulation";
    memory@0 { reg = <0x0 0x20000000>; };
};
''')
        fragment=config_root/'linux.fragment'
        fragment.write_text('''CONFIG_BLK_DEV_INITRD=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_DEVMEM=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_I2C_CHARDEV=y
CONFIG_TMPFS=y
''')
        overlay=config_root/'rootfs-overlay';bundle=overlay/'opt/vvg-cosim'
        bundle.mkdir(parents=True)
        manifest=json.loads((PACKAGE/'deployment_manifest.json').read_text())['sha256']
        copies={}
        for name in ('voice_volume_control.py','voice_volume_runtime.py'):
            copies['scripts/'+name]='board/pynq_z2/scripts/'+name
        for name in ('__init__.py','volume_monitor.py','input_osd.py','osd_publisher.py'):
            copies['python/pynq_multimodal_game/'+name]='python/pynq_multimodal_game/'+name
        hashes={}
        for dest,source in copies.items():
            assert sha(PACKAGE/source)==manifest[source].lower(),source
            target=bundle/dest;target.parent.mkdir(parents=True,exist_ok=True)
            shutil.copyfile(PACKAGE/source,target);hashes[dest]=sha(target)
        shutil.copyfile(Path(__file__).with_name('guest_smoke.py'),bundle/'guest_smoke.py')
        hashes['guest_smoke.py']=sha(bundle/'guest_smoke.py')
        (bundle/'source-hashes.json').write_text(json.dumps(hashes,indent=2))
        startup=overlay/'etc/init.d/S99vvg-cosim-smoke';startup.parent.mkdir(parents=True)
        startup.write_text('#!/bin/sh\n/usr/bin/python3 /opt/vvg-cosim/guest_smoke.py\n')
        startup.chmod(0o755)
        config=f'''BR2_arm=y
BR2_cortex_a9=y
BR2_ARM_ENABLE_NEON=y
BR2_ARM_ENABLE_VFP=y
BR2_TOOLCHAIN_EXTERNAL=y
BR2_TOOLCHAIN_EXTERNAL_BOOTLIN=y
BR2_TOOLCHAIN_EXTERNAL_BOOTLIN_ARMV7_EABIHF_GLIBC_STABLE=y
BR2_JLEVEL=2
BR2_GLOBAL_PATCH_DIR="board/xilinx/patches"
BR2_DOWNLOAD_FORCE_CHECK_HASHES=y
BR2_TARGET_GENERIC_HOSTNAME="vvg-offline-cosim"
BR2_TARGET_GENERIC_GETTY_PORT="ttyPS0"
BR2_SYSTEM_DHCP=""
BR2_ROOTFS_OVERLAY="{overlay}"
BR2_LINUX_KERNEL=y
BR2_LINUX_KERNEL_CUSTOM_TARBALL=y
BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION="$(call github,Xilinx,linux-xlnx,xlnx_rebase_v6.6_LTS_merge_6.6.70)/xlnx_rebase_v6.6_LTS_merge_6.6.70.tar.gz"
BR2_LINUX_KERNEL_DEFCONFIG="xilinx_zynq"
BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="{fragment}"
BR2_LINUX_KERNEL_ZIMAGE=y
BR2_LINUX_KERNEL_DTS_SUPPORT=y
BR2_LINUX_KERNEL_INTREE_DTS_NAME="xilinx/voice-view-cosim"
BR2_LINUX_KERNEL_CUSTOM_DTS_DIR="{config_root/'dts'}"
BR2_LINUX_KERNEL_NEEDS_HOST_OPENSSL=y
BR2_TARGET_ROOTFS_CPIO=y
BR2_TARGET_ROOTFS_CPIO_GZIP=y
# BR2_TARGET_ROOTFS_TAR is not set
BR2_PACKAGE_PYTHON3=y
BR2_PACKAGE_PYTHON3_PY_PYC=y
BR2_PACKAGE_PYTHON3_ZLIB=y
'''
        defconfig=config_root/'voice_view_defconfig';defconfig.write_text(config)
        command=['make','-C',str(a.linux_root/'buildroot'),'O='+str(build),
                 'BR2_DEFCONFIG='+str(defconfig),'defconfig']
        result=subprocess.run(command,capture_output=True,text=True,timeout=120)
        (a.output/'configure.log').write_text(result.stdout+result.stderr)
        assert result.returncode==0,'Buildroot defconfig failed'
        resolved=(build/'.config').read_text()
        for item in ('BR2_cortex_a9=y','BR2_TOOLCHAIN_EXTERNAL_BOOTLIN_ARMV7_EABIHF_GLIBC_STABLE=y',
                     'BR2_PACKAGE_PYTHON3=y','BR2_TARGET_ROOTFS_CPIO_GZIP=y',
                     'BR2_LINUX_KERNEL_INTREE_DTS_NAME="xilinx/voice-view-cosim"'):
            assert item in resolved,'missing requested configuration '+item
        shutil.copyfile(build/'.config',a.output/'buildroot.config')
        record.update(status='LINUX_CONFIGURATION_PASS',linux_output=str(build),
            config_root=str(config_root),command=command,rootfs_source_hashes=hashes,
            generated_hashes={str(path.relative_to(config_root)):sha(path) for path in config_root.rglob('*') if path.is_file()})
    except BaseException as error:
        record.update(status='FAIL',error=repr(error));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(record,indent=2))


if __name__=='__main__':main()
