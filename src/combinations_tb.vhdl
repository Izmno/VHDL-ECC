library ieee;
use ieee.std_logic_1164.all;

library work;
use work.vectors.all;
use work.unittest.all;
use work.unittest_vectors.all;
use work.combinations.all;

entity combinations_tb is
end combinations_tb;

architecture tb of combinations_tb is
begin
    process is
        variable run: testrun_t := create_run(
            "Combinations Unittests", 
            "Basic unittests for all functions in the combinations package"
        );
    begin
        run_test(
            run, 
            "factorial(integer)", 
            "Calculating 5!", 
            120, 
            factorial(5)
        );

        run_test(
            run, 
            "factorial(integer)", 
            "Calculating 0!", 
            1, 
            factorial(0)
        );

        run_test(
            run, 
            "factorial(integer, integer)", 
            "Calculating 5! / 2!", 
            60, 
            factorial(5, 2)
        );

        run_test(
            run, 
            "factorial(integer, integer)", 
            "Calculating 0!/0!", 
            1, 
            factorial(0, 0)
        );

        run_test(
            run, 
            "factorial(integer, integer)", 
            "Calculating 5!/5!", 
            1, 
            factorial(5, 5)
        );

        run_test(
            run, 
            "num_combinations(integer, integer)", 
            "Calculating number of combinations (8 3)", 
            56, 
            num_combinations(8, 3)
        );

        run_test(
            run, 
            "num_combinations(integer, integer)", 
            "Calculating number of combinations (6, 3)", 
            20, 
            num_combinations(6, 3)
        );

        run_test(
            run, 
            "num_combinations(integer, integer)", 
            "Calculating number of combinations (7, 3)", 
            35, 
            num_combinations(7, 3)
        );

        run_test(
            run, 
            "num_combinations(integer, integer)", 
            "Calculating number of combinations (7, 5)", 
            21, 
            num_combinations(7, 5)
        );

        run_test(
            run, 
            "enumerate_combinations(integer, integer)", 
            "Calculating number of combinations (5, 3)", 
            (7, 11, 19, 13, 21, 25, 14, 22, 26, 28),
            enumerate_combinations(5, 3)
        );
        wait;
    end process;
end architecture;