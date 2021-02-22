library ieee;
use ieee.std_logic_1164.all;

library work;
use work.vectors.all;
use work.unittest.all;
use work.unittest_vectors.all;

entity vectors_tb is
end vectors_tb;

architecture tb of vectors_tb is
begin
    
    process is
        variable run: testrun_t := create_run(
            "Vectors Unittests", 
            "Basic unittests for all functions in the vectors package"
        );
    begin
    
        -- zeros
        run_test(run, "zeros(integer, integer)", "Expecting zero matrix of size 3", ("000", "000", "000"), zeros(3, 3));

        -- zeros
        run_test(run, "ones(integer, integer)", "Expecting ones matrix of size 3", ("111", "111", "111"), ones(3, 3));
        
        -- identity
        run_test(run, "identity(integer)", "Generating identity matrix", ("100", "010", "001"), identity(3));            
        
        -- getrow
        run_test(run, "getrow(matrix, integer)", "Getting the 2nd row vector from an identity matrix", "010", getrow(identity(3), 2));

        -- * operator
        run_test(
            run,
            "operator *(vector, vector)",
            "Testing dot product of two vectors",
            '1',
            vector'("001101") * ones(6)
        );

        -- * operator
        run_test(
            run,
            "operator *(vector, matrix)",
            "Testing dot product of two vectors",
            vector'("10010"),
            vector'("10010") * identity(5)
        );
        

        -- & operator
        run_test(
            run,
            "operator &(matrix, vector)",
            "Adding column to the right of a matrix",
            matrix'("1001", "0101", "0011"),
            identity(3) & ones(3)
        );

        -- & operator
        run_test(
            run,
            "operator &(matrix, matrix)",
            "Concatenating 2 matrices",
            matrix'("100111", "010111", "001111"),
            identity(3) & ones(3, 3)
        );
        
        -- transpose square
        run_test( 
            run, 
            "transpose(matrix)",
            "Transposing a square matrix",
            ("011", "110", "011"),
            transpose(matrix'("010", "111", "101"))
        );

        -- transpose non square
        run_test(
            run, 
            "transpose(matrix)",
            "Transposing a non square matrix",
            ("0110", "1100", "0111"),
            transpose(matrix'("010", "111", "101", "001"))
        );

        -- concatenate matrices
        run_test(
            run,
            "concat(matrix, matrix)",
            "Concatenating 3x4 matrix with identity on the right",
            matrix'("0110100", "1100010", "0111001"),
            concat(matrix'("0110", "1100", "0111"), identity(3))
        );

        -- concat identity 
        run_test(
            run, 
            "concat_identity_right(matrix)",
            "Concatenating 3x4 matrix with identity on the right",
            ("0110100", "1100010", "0111001"),
            concat_identity_right(("0110", "1100", "0111"))
        );
        
        -- concat identity left
        run_test(
            run,
            "concat_identity_left(matrix)",
            "Concatenating 3x4 matrix with identity on the left",
            ("1000110", "0101100", "0010111"),
            concat_identity_left(("0110", "1100", "0111"))
        );
        
        -- dot product
        run_test(
            run,
            "dot(matrix, matrix)",
            "Performing dot product of 3x4 with 4x3 matrix",
            ("010", "101", "011"),
            matrix'("0110", "1100", "0111") * matrix'("010", "111", "101", "001")
        );
        
        wait; 
    end process;
    
        
      
end tb ;