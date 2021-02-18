library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

library work;
use work.hamming.all;
use work.vectors.all;
use work.unittest.all;
use work.unittest_hamming.all;
use work.unittest_vectors.all;

entity hamming_tb is
end hamming_tb;

architecture tb of hamming_tb is
begin
    
    process is
        variable run: testrun_t := create_run(
            "Hamming Unittests", 
            "Basic unittests for all functions in the Hamming package"
        ); 
    begin

        run_test(
            run,
            "calc_data_bits(integer)",
            "Run 1: calculating data bits for 3 parity bits. Source: https://en.wikipedia.org/wiki/Hamming_code",
            4,
            calc_data_bits(3)
        );
        
        run_test(
            run,
            "calc_data_bits(integer)",
            "Run 2: calculating data bits for 7 parity bits. Source: https://en.wikipedia.org/wiki/Hamming_code",
            120,
            calc_data_bits(7)
        );
        
        run_test(
            run,
            "calc_parity_bits(integer)",
            "Run 1: calculating data bits for 26 data bits. Source: https://en.wikipedia.org/wiki/Hamming_code",
            5,
            calc_parity_bits(26)
        );
        
        run_test(
            run,
            "calc_parity_bits(integer)",
            "Run 1: calculating data bits for 64 data bits. Source: https://en.wikipedia.org/wiki/Hamming_code",
            7,
            calc_parity_bits(64)
        );

        run_test(
            run,
            "init_hamming(integer, boolean)",
            "Initializing hamming parameters",
            hamming_t'(
                parity_bits => 4,
                total_parity_bits => 5,
                max_data_bits => 11,
                max_total_bits => 16,
                data_bits => 8,
                total_bits => 13,
                extended => true
            ),
            init_hamming(8, true)
        );

        run_test(
            run,
            "init_hamming(integer, boolean)",
            "Initializing hamming parameters",
            hamming_t'(
                parity_bits => 6,
                total_parity_bits => 6,
                max_data_bits => 57,
                max_total_bits => 63,
                data_bits => 32,
                total_bits => 38,
                extended => false
            ),
            init_hamming(32, false)
        );
        
        run_test(
            run,
            "calc_nonpower(integer)",
            "Calculating list of positive integers < 2 ** 4 which are not a power of 2",
            (3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15),
            calc_nonpower(4)
        );

        run_test(
            run,
            "calc_nonpower(integer)",
            "Calculating list of positive integers < 2 ** 6 which are not a power of 2",
            (
            3, 5, 6, 7, 9, 10, 11, 12, 
            13, 14, 15, 17, 18, 19, 20, 
            21, 22, 23, 24, 25, 26, 27, 
            28, 29, 30, 31, 33, 34, 35, 
            36, 37, 38, 39, 40, 41, 42, 
            43, 44, 45, 46, 47, 48, 49, 
            50, 51, 52, 53, 54, 55, 56, 
            57, 58, 59, 60, 61, 62, 63
            ),
            calc_nonpower(6)
        );

        run_test(
            run,
            "base_matrix(integer, boolean)",
            "",
            matrix'("011", "101", "110", "111"),
            base_matrix(3, false)
        );

        run_test(
            run,
            "base_matrix(integer, boolean)",
            "",
            matrix'("0111", "1011", "1101", "1110"),
            base_matrix(3, true)
        );

        run_test(
            run, 
            "generator_matrix(integer, boolean)",
            "",
            matrix'("1000011", "0100101", "0010110", "0001111"),
            generator_matrix(3, false)
        );

        run_test(
            run, 
            "generator_matrix(integer, boolean)",
            "",
            matrix'("10000111", "01001011", "00101101", "00011110"),
            generator_matrix(3, true)
        );

        run_test(
            run, 
            "parity_check_matrix(integer, boolean)",
            "",
            ("0111100", "1011010", "1101001"),
            parity_check_matrix(3, false)
        );

        run_test(
            run, 
            "parity_check_matrix(integer, boolean)",
            "",
            ("01111000", "10110100", "11010010", "11100001"),
            parity_check_matrix(3, true)
        );

        run_test(
            run, 
            "encode(integer, boolean, std_logic_vector)",
            "Encoding a 4 bit string without extra parity bit",
            "1011010",
            encode(3, false, "1011")
        );

        run_test(
            run, 
            "encode(integer, boolean, std_logic_vector)",
            "Encoding a 4 bit string with extra parity bit",
            "10110100",
            encode(3, true, "1011")
        );
        
        run_test(
            run, 
            "encode(integer, boolean, std_logic_vector)",
            "Encoding a 4 bit string with too many parity bits according to spec",
            "0000000000000000000000101111101",
            encode(5, false, "1011")
        );

        run_test(
            run, 
            "encode(integer, boolean, std_logic_vector)",
            "Encoding a 9 bit string with too little parity bits according to spec",
            "0010110",
            encode(3, false, "010010010")
        );


        run_test(
            run, 
            "encode(integer, integer, boolean, std_logic_vector)",
            "Encoding a 32 bit string with with extended hamming code",
            "010101011010101011111111001000100001001",
            encode(6, 32, true, "01010101" & "10101010" & "11111111" & "00100010")
        );

        run_test(
            run, 
            "encode(integer, integer, boolean, std_logic_vector)'length",
            "Checking length of output vector in previous example",
            39,
            encode(6, 32, true, "01010101" & "10101010" & "11111111" & "00100010")'length
        );
        wait; 
    end process;
        
      
end tb ;