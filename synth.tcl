create_project synth/ecc 

# set the correct working directory
# https://www.xilinx.com/support/answers/55743.html
cd [get_property DIRECTORY [current_project]]

add_files -norecurse { \
    ../src/ecc.vhdl \
    ../src/ecc_tb.vhdl \
    ../src/unittest.vhdl \
    ../src/unittest_vectors.vhdl \
    ../src/unittest_hamming.vhdl \
    ../src/vectors.vhdl \
    ../src/biterror.vhdl \
    ../src/hamming.vhdl \
    ../src/spc.vhdl \
}


set_property top ecc [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 2