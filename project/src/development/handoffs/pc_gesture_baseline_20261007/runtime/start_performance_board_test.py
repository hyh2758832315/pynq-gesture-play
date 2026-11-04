"""Independent r8 performance candidate. Validation is the default."""
import argparse
import importlib
from pathlib import Path
import sys

import start_4way_board_test as fourway
from performance_policy import configure_tracker


def install_backend_policy(cli, root, mode):
    original = cli._create_shared_vision_backend
    def create(args):
        scripts = root / 'board/pynq_z2/scripts'
        sys.path.insert(0, str(scripts))
        runtime = importlib.import_module('vision_async_runtime')
        if Path(runtime.__file__).resolve() != scripts / 'vision_async_runtime.py':
            raise ImportError('Unexpected performance runtime source')
        if runtime.RUNTIME_DIR.resolve() != root / 'handoffs/gesture_vision_v61/runtime':
            raise ImportError('Unexpected gesture runtime directory')
        configure_tracker(runtime, mode)
        return original(args)
    cli._create_shared_vision_backend = create


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mode', choices=('validation', 'performance'), default='validation')
    args, remaining = parser.parse_known_args(argv)
    # Verify the same frozen root before installing process-local policy.
    root_parser = argparse.ArgumentParser(add_help=False)
    root_parser.add_argument('--deployment', type=Path, default=fourway.launcher.R8_ROOT)
    root_args, _ = root_parser.parse_known_args(remaining)
    root = fourway.launcher.verify(root_args.deployment)
    original_configure = fourway.configure_provider
    def configure(cli):
        original_configure(cli)
        install_backend_policy(cli, root, args.mode)
        print('VISION_MODE=' + args.mode.upper(), flush=True)
        print('CPU_SKIN_GOLDEN=' + ('EVERY_FRAME' if args.mode == 'validation' else 'DISABLED_EXPLICIT_OPT_IN'), flush=True)
        print('PERFORMANCE_CANDIDATE; DMA/gesture gates retained; NOT board accepted', flush=True)
    fourway.configure_provider = configure
    return fourway.main(remaining)


if __name__ == '__main__':
    raise SystemExit(main())
