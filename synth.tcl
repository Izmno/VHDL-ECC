create_project synth/ecc -part xc7a35tcpg236-1

# set the correct working directory
# https://www.xilinx.com/support/answers/55743.html
cd [get_property DIRECTORY [current_project]]

add_files -norecurse { \
    ../src/components/syndrome_decoder.vhdl
    ../src/components/mask_generator.vhdl
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


set_property top syndrome_decoder [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 2
launch_runs impl_1 -jobs 2