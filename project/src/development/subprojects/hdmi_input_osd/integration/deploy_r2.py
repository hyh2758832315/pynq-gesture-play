"""Bind the reviewed deployment recipe to R2, preserving every R1 receipt.

Run: python -B .../deploy_r2.py stage|preflight|stop|closed|start|ready
Use --restart for the later clean R2->R2 restart, which omits test-stimuli.
Output: unique g26/g27/g28 receipts; restart uses g31 names.
Next: strict board performance/readback and final clean-restart evidence.
"""
import argparse
import ast
import runpy

import board_common as common


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('action',choices=('stage','preflight','stop','closed','start','ready'))
    parser.add_argument('--restart',action='store_true')
    args=parser.parse_args()
    newroot='/home/xilinx/voice-view-game/c6i-vision-volume-osd-r16-20261023-r2'
    recipe=runpy.run_path(str(common.HERE/'board_deploy.py'))
    glob=recipe['stage'].__globals__
    glob.update(BOARD=newroot,CHILD=common.REPO/'deliveries/c6i-vision-volume-osd-r16-20261023-r2',
        OLD=newroot if args.restart else common.BOARD,
        OLD_LOG='var/osd-r2-live-r01' if args.restart else 'var/osd-live-r02',
        LOG='var/osd-r2-live-r02' if args.restart else 'var/osd-r2-live-r01')
    names={'g15-package':'g25-r2-package','g16-stage-create':'g26-stage-create','g16-scp':'g26-scp',
        'g16-stage-arm-contract':'g26-stage-arm-contract','g16-old-preflight':'g26-old-preflight',
        'g17-normal-stop-old':'g27-normal-stop-old','g17-old-clean-closed':'g27-old-clean-closed',
        'g18-c0d-start':'g28-r2-start','g18-c0d-ready':'g28-r2-ready'}
    if args.restart:
        assert args.action!='stage'
        names.update({'g16-old-preflight':'g31-restart-preflight','g17-normal-stop-old':'g31-restart-normal-stop',
            'g17-old-clean-closed':'g31-restart-clean-closed','g18-c0d-start':'g31-final-start','g18-c0d-ready':'g31-final-ready'})
    def remote(name,source,**options):
        if name=='g16-stage-arm-contract':
            marker='for command in commands:\n'
            assert source.count(marker)==1
            source=source.replace(marker,"commands.append([sys.executable,'-B',str(root/'tools/osd_preview_shutdown_contract.py')])\n"+marker)
        if args.restart and name=='g18-c0d-start':
            marker=", '--osd-test-stimuli']"
            assert source.count(marker)==1
            source=source.replace(marker,']')
        ast.parse(source,feature_version=(3,10))
        return common.remote(names[name],source,**options)
    glob['remote']=remote
    glob['load']=lambda name: common.load(names[name])
    glob['save']=lambda name,value: common.save(names[name],value)
    glob['inspect_source']=lambda: common.inspect_source(current=glob['OLD'],log=glob['OLD_LOG'])
    glob[args.action]()


if __name__=='__main__': main()
