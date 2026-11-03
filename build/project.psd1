@{
    # sEMG-HMRS project configuration for build_all.ps1 (generic engine).
    # All paths are relative to the repo root. build_all.ps1 extracts the
    # expected parameter VALUES from the RTL declaration file at runtime -
    # the single source of truth - so only names/patterns live here.

    # Toolchain
    # Leave empty to resolve vivado.bat from AMD_VIVADO_ROOT or PATH.
    VivadoBat = ''

    # Project layout
    ProjectXpr       = 'build\vivado\hand_motion_reconstruction.xpr'
    BitFile          = 'build\vivado\hand_motion_reconstruction.runs\impl_1\design_1.bit'
    BootBin          = 'build\boot\BOOT.BIN'
    FsblElf          = 'build\vitis_ws\platform\export\platform\sw\boot\fsbl.elf'
    AppElf           = 'sw\ps_uart_print\ps_uart_print.elf'
    CheckLog         = 'build\check_design.log'
    CheckJou         = 'build\check_design.jou'
    RunsDir          = 'build\vivado\hand_motion_reconstruction.runs'
    TimingRptPattern = '*timing_summary*routed*.rpt'

    # Gate 1: parameters to guard. Values are auto-extracted from the
    # `parameter integer NAME = VALUE` declarations in ParamSourceRtl.
    # The OOC synth run's runme.log is located by this substring pattern.
    ParamSourceRtl = 'src\rtl\emg_pl_export.v'
    GuardedParams  = @('HP_B0', 'HP_B1', 'HP_B2', 'HP_A1', 'HP_A2', 'LP_ALPHA')
    OocRunPattern  = 'emg_pl_export'

    # Gate 2: RTL parameter name -> netlist coefficient register suffix
    # (keys must cover GuardedParams; bit widths live inside
    # tools/verify_coeff_regs.py)
    NetlistRegMap = @{
        HP_B0    = 'b0_r'
        HP_B1    = 'b1_r'
        HP_B2    = 'b2_r'
        HP_A1    = 'a1_r'
        HP_A2    = 'a2_r'
        LP_ALPHA = 'alpha_r'
    }
}
