"""Independent v5 selected-stage preview candidate; validation remains default."""
import start_performance_board_test as performance


def main(argv=None):
    original = performance.configure_tracker
    def configure(runtime, mode):
        tracker = original(runtime, mode)
        from single_stage_preview import install
        install(runtime)
        return tracker
    performance.configure_tracker = configure
    print('PREVIEW_POLICY=SELECTED_STAGE; debug ceiling=5Hz; legacy six-panel retained', flush=True)
    return performance.main(argv)


if __name__ == '__main__':
    raise SystemExit(main())
