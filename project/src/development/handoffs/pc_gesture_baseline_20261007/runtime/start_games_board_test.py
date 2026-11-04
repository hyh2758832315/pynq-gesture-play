"""v7 game-specific gesture input; inherits v6 preview and performance policy."""
import start_scheduled_preview_board_test as scheduled


def main(argv=None):
    performance = scheduled.preview.performance
    original_tracker = performance.configure_tracker

    def configure_tracker(runtime, mode):
        tracker = original_tracker(runtime, mode)
        from multi_game_input import install_classification
        install_classification(runtime)
        return tracker

    def configure_provider(cli):
        # Invoked only after the full frozen deployment SHA validation.
        from multi_game_input import MultiGameVisionInputProvider, install_game_routing
        cli.VisionInputProvider = MultiGameVisionInputProvider
        install_game_routing()
        print('GAME_INPUT=game1:FOUR_WAY_JUMP; game2:STABLE_RPS; game3:LEFT_RIGHT_JUMP_SELECT', flush=True)
        print('GAME3_AUDIO=UNCHANGED; gesture integration only; BOARD_ACCEPTANCE=PENDING', flush=True)

    performance.configure_tracker = configure_tracker
    performance.fourway.configure_provider = configure_provider
    return scheduled.main(argv)


if __name__ == '__main__':
    raise SystemExit(main())
