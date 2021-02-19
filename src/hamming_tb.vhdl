library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library work;
use work.hamming.all;
use work.vectors.all;
use work.unittest.all;
use work.unittest_hamming.all;
use work.unittest_vectors.all;
use work.biterror.all;

entity hamming_tb is
end hamming_tb;

architecture tb of hamming_tb is
begin
    
    process is
        variable run: testrun_t := create_run(
            "Hamming Unittests", 
            "Basic unittests for all functions in the Hamming package"
        ); 


        variable data : std_logic_vector(7 downto 0);
        variable code : std_logic_vector(11 downto 0);
        variable code_extended : std_logic_vector(12 downto 0);
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





        -- ERROR INDEX (NOT EXTENDED)

        data := "01101010";

        run_test(
            run, 
            "get_error_index(syndrome(encode()))",
            "Getting error index of decoded codeword without errors (not extended)",
            15,
            get_error_index(syndrome(4, false, encode(4, 8, false, data)), 15, false)
        );

        for i in 0 to 10 loop
            code := encode(4, 8, false, data);
            code := flip_bit(code, i);
            run_test(
                run, 
                "get_error_index(syndrome(encode()))",
                "Getting error index of decoded codeword with error on bit " & integer'image(i) & ". (not extended)",
                i,
                get_error_index(syndrome(4, false, code), 15, false)
            );

        end loop;


        -- ERROR INDEX (EXTENDED)

        data := "01101010";

        run_test(
            run, 
            "get_error_index(syndrome(encode()))",
            "Getting error index of decoded codeword without errors (extended)",
            16,
            get_error_index(syndrome(4, true, encode(4, 8, true, data)), 16, true)
        );

        for i in 0 to 11 loop
            code_extended := encode(4, 8, true, data);
            code_extended := flip_bit(code_extended, i);
            run_test(
                run, 
                "get_error_index(syndrome(encode()))",
                "Getting error index of decoded codeword with error on bit " & integer'image(i) & ". (extended)",
                i,
                get_error_index(syndrome(4, true, code_extended), 16, true)
            );

        end loop;

        -- DATA ERROR INDEX (NOT EXTENDED)

        data := "01101010";

        run_test(
            run, 
            "get_data_error_index(syndrome(encode()))",
            "Getting data error index of decoded codeword without errors (not extended)",
            11,
            get_data_error_index(syndrome(4, false, encode(4, 8, false, data)), 4, 11, false)
        );

        for i in 0 to 7 loop
            code := encode(4, 8, false, data);
            code := flip_bit(code, i + 4);
            run_test(
                run, 
                "get_data_error_index(syndrome(encode()))",
                "Getting data error index of decoded codeword with error on bit " & integer'image(i) & ". (not extended)",
                i,
                get_data_error_index(syndrome(4, false, code), 4, 11, false)
            );

        end loop;


        -- DATA ERROR INDEX (EXTENDED)

        data := "01101010";

        run_test(
            run, 
            "get_data_error_index(syndrome(encode()))",
            "Getting data error index of decoded codeword without errors (extended)",
            11,
            get_data_error_index(syndrome(4, true, encode(4, 8, true, data)), 4, 11, true)
        );

        for i in 0 to 7 loop
            code_extended := encode(4, 8, true, data);
            code_extended := flip_bit(code_extended, i + 5);
            run_test(
                run, 
                "get_data_error_index(syndrome(encode()))",
                "Getting data error index of decoded codeword with error on bit " & integer'image(i) & ". (extended)",
                i,
                get_data_error_index(syndrome(4, true, code_extended), 4, 11, true)
            );

        end loop;

        -- ERROR MASK (EXTENDED)

        data := "01101010";

        run_test(
            run, 
            "get_error_mask(syndrome(encode()))",
            "Getting error mask of decoded codeword without errors (extended)",
            "00000000",
            get_error_mask(syndrome(4, true, encode(4, 8, true, data)), 4, 11, true, 8)
        );

        for i in 0 to 4 loop
            code_extended := encode(4, 8, true, data);
            code_extended := flip_bit(code_extended, i);
            run_test(
                run, 
                "get_error_mask(syndrome(encode()))",
                "Getting error mask of decoded codeword with error on checkbit " & integer'image(i) & ". (extended)",
                "00000000",
                get_error_mask(syndrome(4, true, code_extended), 4, 11, true, 8)
            );
        end loop;


        for i in 0 to 7 loop
            code_extended := encode(4, 8, true, data);
            code_extended := flip_bit(code_extended, i + 5);
            run_test(
                run, 
                "get_error_mask(syndrome(encode()))",
                "Getting error mask of decoded codeword with error on bit " & integer'image(i) & ". (extended)",
                std_logic_vector(to_unsigned(2 ** i, 8)),
                get_error_mask(syndrome(4, true, code_extended), 4, 11, true, 8)
            );

        end loop;

        

        wait; 
    end process;
        
      
end tb ;