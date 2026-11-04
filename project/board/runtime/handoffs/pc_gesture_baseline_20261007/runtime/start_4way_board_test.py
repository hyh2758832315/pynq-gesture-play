"""Four-way movement plus open-to-fist jump on the verified r8 runtime."""
import start_jump_board_test as launcher


def configure_provider(cli):
    # Import only after launcher.main verifies the deployment and selects its
    # Python modules. Never import an unverified installed runtime first.
    from four_way_input import FourWayVisionInputProvider
    cli.VisionInputProvider = FourWayVisionInputProvider
    print('CONTROL_MAPPING=LEFT/RIGHT/UP/DOWN; UP=-hand_y DOWN=+hand_y', flush=True)


def main(argv=None):
    launcher.configure_provider = configure_provider
    launcher.CONTROL_NOTICE = ('JUMP_OPT_IN=HEURISTIC_OPEN_TO_FIST; '
                               'horizontal unchanged; vertical enabled')
    return launcher.main(argv)


if __name__ == '__main__':
    raise SystemExit(main())
