from vunit import VUnit


def encode(tb_cfg):
    return ", ".join(["%s:%s" % (key, str(tb_cfg[key])) for key in tb_cfg])

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("./*.vhd")

lib.add_source_file("../../AtomBusMon/src/AlanD/R65Cx2.vhd")
lib.add_source_file("../../src/common/SID/sid_6581.vhd")
lib.add_source_file("../../src/common/SID/sid_coeffs.vhd")
lib.add_source_file("../../src/common/SID/sid_components.vhd")
lib.add_source_file("../../src/common/SID/sid_filters.vhd")
lib.add_source_file("../../src/common/SID/sid_voice.vhd")
lib.add_source_file("../../AtomBusMon/src/T6502/T65.vhd")
lib.add_source_file("../../AtomBusMon/src/T6502/T65_ALU.vhd")
lib.add_source_file("../../AtomBusMon/src/T6502/T65_MCode.vhd")
lib.add_source_file("../../AtomBusMon/src/T6502/T65_Pack.vhd")
lib.add_source_file("../../src/common/bbc_micro_core.vhd")
lib.add_source_file("../../src/common/keyboard.vhd")
lib.add_source_file("../../src/common/m6522.vhd")
lib.add_source_file("../../src/common/mc6845.vhd")
lib.add_source_file("../../src/common/mouse/ps2interface.vhd")
lib.add_source_file("../../src/common/mouse/quadrature_controller.vhd")
lib.add_source_file("../../src/common/mouse/quadrature_fsm.vhd")
lib.add_source_file("../../src/common/rtc.vhd")
lib.add_source_file("../../src/common/saa5050.vhd")
lib.add_source_file("../../src/common/saa5050_rom_dual_port.vhd")
lib.add_source_file("../../src/common/scandoubler/mist_scandoubler.vhd")
lib.add_source_file("../../src/common/scandoubler/retimer.vhd")
lib.add_source_file("../../src/common/scandoubler/rgb2vga_dpram.vhd")
lib.add_source_file("../../src/common/scandoubler/rgb2vga_scandoubler.vhd")
lib.add_source_file("../../src/common/sn76489.vhd")
lib.add_source_file("../../src/common/spi.vhd")
lib.add_source_file("../../src/common/upd7002.vhd")
lib.add_source_file("../../src/common/vidproc.vhd")
lib.add_source_file("../../src/common/vidproc_orig.vhd")

lib.add_source_file("../../src/xilinx/spi_flash.vhd")

lib.add_source_file("../../src/gowin/gowin_tang_primer25k/src/bbc_micro_tang_primer25k.vhd")
lib.add_source_file("../../src/gowin/gowin_tang_primer25k/src/gowin_pll/pll_27_135.vhd")
lib.add_source_file("../../src/gowin/gowin_tang_primer25k/src/gowin_pll/pll_48_96.vhd")
lib.add_source_file("../../src/gowin/gowin_tang_primer25k/src/mem_tang_25k.vhd")
lib.add_source_file("../../src/gowin/gowin_tang_primer25k/src/bootstrap.vhd")

lib.add_source_files("C:/Gowin/Gowin_V1.9.9.02_x64/IDE/simlib/gw5a/prim_sim.vhd")

fmf = vu.add_library("fmf")
fmf.add_source_files("../library/fmf/*.vhd")


vu.set_sim_option("disable_ieee_warnings",1)

# Run vunit function
vu.main()
