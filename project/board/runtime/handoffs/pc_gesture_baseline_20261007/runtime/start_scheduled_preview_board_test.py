"""Independent v6 admission-clock candidate. Default: validation."""
import start_preview_board_test as preview


def main(argv=None):
    original = preview.performance.configure_tracker
    def configure(runtime, mode):
        tracker = original(runtime, mode)
        # v5 installs its renderer/encoder first; timing wraps that same encoder.
        from single_stage_preview import install as install_stage
        from preview_schedule import install as install_schedule
        install_stage(runtime)
        install_schedule(runtime)
        return tracker
    # Call performance directly to avoid installing the v5 renderer twice.
    preview.performance.configure_tracker = configure
    print('PREVIEW_POLICY=SELECTED_STAGE; SCHEDULE=PRE_INFERENCE_CLOCK; target debug=5Hz', flush=True)
    return preview.performance.main(argv)


if __name__ == '__main__':
    raise SystemExit(main())
