"""Explicit18s audio-only rules check; no game dispatch or automatic recovery."""
from pathlib import Path
import importlib.util

if __name__=='__main__':
    root=Path(__file__).resolve().parent
    spec=importlib.util.spec_from_file_location('_guarded_rules_runner',root/'run_live_voice_test.py')
    runner=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    print('18秒声音规则检查：将进行一次声音DMA干净启动，不加载BIT、不控制游戏。',flush=True)
    runner.main(['--rules-18s','--reset-audio-dma-before-record','--cpu-worker',
        '--poll-budget-ms','15','--optimize-receive','--pin-cpu','--energy-onset-candidate',
        '--control-budget','--pll-budget','--health-budget'])
