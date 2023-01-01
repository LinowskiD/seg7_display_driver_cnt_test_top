from vunit import VUnit, VUnitCLI
from pathlib import Path
import sys
import os

# MODULE_NAME
MODULE_NAME = "tim_upcnt_16bit"
# VHDL version
VHDL_STANDARD = "2008"
# ROOT
ROOT_PATH = Path(__file__).resolve().parents[1]
# WORK
WORK_FOLDER_NAME = "work"
# Sources path for DUT
DUT_PATH = ROOT_PATH / "hdl"
# Sources path for TB
TEST_PATH = ROOT_PATH / "hdl_tb"

# Append arguments to VUnit call
cli = VUnitCLI()
cli.parser.set_defaults(output_path=f"{ROOT_PATH / WORK_FOLDER_NAME}")
args = cli.parse_args()
# Create VUnit instance by parsing command line arguments
vu = VUnit.from_args(args=args)
vu.enable_location_preprocessing()
# Create design library
module_lib = vu.add_library(f"{MODULE_NAME}_lib")
# Add design source files to module_lib
module_lib.add_source_files([DUT_PATH / "*.vhd"], vhdl_standard=VHDL_STANDARD)
# Create testbench library
tb_lib = vu.add_library(f"{MODULE_NAME}_tb_lib")
# Add testbench source files to tb_lib
tb_lib.add_source_files([TEST_PATH / "*.vhd"], vhdl_standard=VHDL_STANDARD)
# Run vunit function
vu.main()