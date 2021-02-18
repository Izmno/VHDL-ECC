-- MIT License 
-- 
-- Copyright (c) 2021 Simon De Meyere
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy 
-- of this software and associated documentation files (the "Software"), to deal 
-- in the Software without restriction, including without limitation the rights 
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
-- copies of the Software, and to permit persons to whom the Software is 
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Author(s):       Simon De Meyere
-- 
-- File Name:       vectors.vhdl
-- File Type:       VHDL Package
--
-- Create Date:     11 feb 2021
-- Design Name:     vectors
-- Module Name:     vectors
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
--    Package provides basic linear algebra functions on GF2.
--
--    3 data types are introduced. 'matrix' for two dimensional arrays,
--    'vector' for one dimensional arrays and 'tuple' which is a 
--    one dimensional array of integers representing sizes of matrices or
--    indices of elements of matrices.
--    Where possible or necessary, these data types have standardized 
--    ascending ranges going from 1 to their length.
-- 
--    An auxiliary data type (intvec_t) is defined to help with some utility
--    function
-- 
--    Standard VHDL boolean operators are provided for these data types
--    which are always interpreted as elementwise operations,
--    as well as '+' (xor, addition), '*' (and, multiplication, 
--    dot product) and '**' (outer product, kronecker product). 
--    The last one is deemed appropriate as exponentiation of matrices in 
--    GF2 is trivial.
--
--    Utility functions such as to_string and slicing functions are provided
--    for these data types, and conversions between these data types and 
--    other standard VHDL (including ieee.std_logic_1164) data types.
--
--    Scalar elements of GF2 are represented by std_logic, such that
--    functions defined in this package are synthesizable, though
--    variables are only ever assigned boolean values of '1' and '0' by
--    functions of this package. Resolution of other values of std_logic
--    is handled by the default implementation of ieee.std_logic_1164
--
-- Dependencies:
--   - (ieee.std_logic_1164) 
--   - (std.textio)
--
-- Revision:        0.01
-- Revision log:    0.01 - File Created (11 feb 2021)
--
-- Additional Comments:
--
-- Known bugs/limitations:
-- 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

package vectors is     
    -----------------------------
    -- TYPE DEFINITIONS
    -----------------------------
    type matrix is array (integer range <>, integer range <>) of std_logic;
    type vector is array (integer range <>) of std_logic;
    type tuple is array (1 to 2) of integer;
    type intvec_t is array ( integer range <> ) of integer;

    
    -----------------------------
    -- OPERATOR PROTOTYPES
    -----------------------------
    --   ===================
    --   == GF2 Operators ==
    --   ===================
	-- function "!"   (a    : std_logic) return std_logic; -- i like using ! but i can't it would seem
	function "+"   (a, b : std_logic) return std_logic;
	-- function "^"   (a, b : std_logic) return std_logic; -- i like using ^ but i can't it would seem
	function "*"   (a, b : std_logic) return std_logic;

    --   ======================
    --   == Vector Operators ==
    --   ======================
    --   == BITWISE OPERATIONS ==
    function "+"   (a, b : vector) return vector;
    -- function "^"   (a, b : vector) return vector;
    -- function "*"   (a, b : vector) return vector;  JUST USE AND, * IS BETTER RESERVED FOR DOT PRODUCT
	function "not" (a    : vector) return vector;
	-- function "!"   (a    : vector) return vector;  -- i like using ! but i can't it would seem
	function "and" (a, b : vector) return vector;
	function "or"  (a, b : vector) return vector;
	function "xor" (a, b : vector) return vector;
	function "nand"(a, b : vector) return vector;
	function "nor" (a, b : vector) return vector;
	function "xnor"(a, b : vector) return vector;

    --   == SCALAR MULTIPLICATION WITH GF2 ==
    function "*"   (a: std_logic; b: vector) return vector; 
    function "*"   (a: vector; b: std_logic) return vector; 
    -- function "."   (a: std_logic; b: vector) return vector;
    -- function "."   (a: vector; b: std_logic) return vector; 

    --   == SCALAR MULTIPLICATION WITH Z ==
    function "*"   (a: integer; b: vector) return vector; 
    function "*"   (a: vector; b: integer) return vector; 
    -- function "."   (a: integer; b: vector) return vector;
    -- function "."   (a: vector; b: integer) return vector; 

    --   == DOT PRODUCT ==
    function "*"   (a, b: vector) return std_logic;
    -- function "dot" (a, b: vector) return std_logic;
    -- function "."   (a, b: vector) return std_logic;

    --   == OUTER PRODUCT ==
    function "**"   (a, b: vector) return matrix;



    --   ======================
    --   == Matrix Operators ==
    --   ======================
    --   == BITWISE OPERATIONS ==
    function "+"   (a, b : matrix) return matrix;
    -- function "^"   (a, b : matrix) return matrix;
    -- function "*"   (a, b : matrix) return matrix;  JUST USE AND, * IS BETTER RESERVED FOR DOT PRODUCT
	-- function "!"   (a    : matrix) return matrix; -- i like using ! but i can't it would seem
	function "not" (a    : matrix) return matrix;
	function "and" (a, b : matrix) return matrix;
	function "or"  (a, b : matrix) return matrix;
	function "xor" (a, b : matrix) return matrix;
	function "nand"(a, b : matrix) return matrix;
	function "nor" (a, b : matrix) return matrix;
	function "xnor"(a, b : matrix) return matrix;

    --   == SCALAR MULTIPLICATION WITH GF2 ==
    function "*"   (a: std_logic; b: matrix) return matrix; 
    function "*"   (a: matrix; b: std_logic) return matrix; 
    -- function "."   (a: std_logic; b: matrix) return matrix;
    -- function "."   (a: matrix; b: std_logic) return matrix; 

    --   == SCALAR MULTIPLICATION WITH Z ==
    function "*"   (a: integer; b: matrix) return matrix; 
    function "*"   (a: matrix; b: integer) return matrix; 
    -- function "."   (a: integer; b: vector) return vector;
    -- function "."   (a: vector; b: integer) return vector; 

    --   == MATRIX PRODUCT (dot product) ==
    function "*"   (a, b: matrix) return matrix;
    -- function "dot" (a, b: matrix) return matrix;
    -- function "."   (a, b: matrix) return matrix;

    --   == MATRIX PRODUCT WITH VECTOR (dot product) ==
    function "*"   (a: vector; b: matrix) return vector;
    -- function "dot" (a: vector; b: matrix) return vector;
    -- function "."   (a: vector; b: matrix) return vector;
    function "*"   (a: matrix; b: vector) return vector;
    -- function "dot" (a: matrix; b: vector) return vector;
    -- function "."   (a: matrix; b: vector) return vector;

    --   == KRONECKER PRODUCT (outer product) ==
    function "**"   (a, b: matrix) return matrix;


    --   ============================
    --   == Other Matrix Operators ==
    --   ============================
    function "&" (a, b: matrix) return matrix;
    function "&" (a: matrix; b: vector) return matrix;
    function "&" (a: vector; b: matrix) return matrix;


    -----------------------------
    -- Function PROTOTYPES
    -----------------------------
    --   ==========================
    --   == Assignment Functions ==
    --   ==========================
    function zeros(n: integer) return vector;
    function zeros(m, n: integer) return matrix;
    function zeros(s: tuple) return matrix; 

    function ones(n: integer) return vector;
    function ones(m, n: integer) return matrix;
    function ones(s: tuple) return matrix;

    function identity(n: integer) return matrix; 

    function column(a: vector) return matrix;
    function row(a: vector) return matrix;

    --   ==========================
    --   == Conversion functions ==
    --   ==========================
    function to_logic_vector(a: vector) return std_logic_vector;
    function to_vector(a: std_logic_vector) return vector;
    function mod2(a: integer) return std_logic;

    --   =======================
    --   == Matrix Properties ==
    --   =======================
    function size(a: vector) return integer;
    function size(a: matrix) return tuple;
    
    function iscolumn(a: matrix) return boolean;
    function isrow(a: matrix) return boolean;
    function issquare(a: matrix) return boolean;
    function issingular(a: matrix) return boolean;

    --   =======================
    --   == Slicing Functions ==
    --   =======================
    function getrow(a: matrix; n: integer) return vector;
    function getcolumn(a: matrix; n: integer) return vector;

    --   ===========================
    --   == Utilities and Aliases ==
    --   ===========================
    function transpose(a: matrix) return matrix;
    function transpose(a: vector) return vector;
    function transpose(a: std_logic) return std_logic;
    function concat(a, b: matrix) return matrix; 
    function concat_identity_left(m: matrix) return matrix;
    function concat_identity_right(m: matrix) return matrix; 
    function dot(a, b: vector) return std_logic;
    function dot(a: vector; b: matrix) return vector;
    function dot(a: matrix; b: vector) return vector;
    function dot(a, b: matrix) return matrix;

    --   ======================
    --   == String functions ==
    --   ======================
    function to_string(a: matrix) return string;
    function to_string(a: vector) return string;
    function to_string(a: tuple) return string;
    function to_string(a: std_logic_vector) return string;
    function to_string(v: intvec_t) return string;
    function pkg_matrix_to_string(a: std_logic) return string; 

    


end package vectors;


package body vectors is
    ------------------------------
    -- OPERATOR IMPLEMENTATIONS --
    ------------------------------
    --   ===================
    --   == GF2 Operators ==
    --   ===================
	-- function "!"   (a    : std_logic) return std_logic is 
    -- begin 
    --     return not a;
    -- end function;

	function "+"   (a, b : std_logic) return std_logic is
    begin 
        return a xor b;
    end function;

	-- function "^"   (a, b : std_logic) return std_logic is 
    -- begin 
    --     return a xor b;
    -- end function;

	function "*"   (a, b : std_logic) return std_logic is 
    begin 
        return a and b;
    end function;

    --   ======================
    --   == Vector Operators ==
    --   ======================
    --   == BITWISE OPERATIONS ==
    function "+"   (a, b : vector) return vector is 
        variable a_std : vector(1 to a'length) := a;
        variable b_std : vector(1 to b'length) := b;
        variable o_std : vector(1 to a'length);
    begin 
        assert a'length = b'length
            report "Incompatible length for elementwise vector addition"
            severity error;
        for i in o_std'range loop
            o_std(i) := a_std(i) + b_std(i);
        end loop;
        return o_std;
    end function;

    -- function "^"   (a, b : vector) return vector is 
    -- begin 
    --     return a + b;
    -- end function;
        
    -- function "*"   (a, b : vector) return vector is  JUST USE AND, * IS BETTER RESERVED FOR DOT PRODUCT
    --     variable a_std : vector(1 to a'length) := a;
    --     variable b_std : vector(1 to b'length) := b;
    --     variable o_std : vector(1 to a'length);
    -- begin 
    --     assert a'length = b'length
    --         report "Incompatible length for elementwise vector multiplication"
    --         severity error;
    --     for i in o_std'range loop
    --         o_std(i) := a_std(i) * b_std(i);
    --     end loop;
    --     return o_std;
    -- end function;

	function "not" (a    : vector) return vector is
        variable a_std : vector(1 to a'length) := a;
        variable o_std : vector(1 to a'length);
    begin 
        for i in o_std'range loop
            o_std(i) := not a_std(i);
        end loop;
        return o_std;
    end function;

	-- function "!"   (a    : vector) return vector is
    -- begin 
    --     return not a;
    -- end function;

	function "and" (a, b : vector) return vector is 
        variable a_std : vector(1 to a'length) := a;
        variable b_std : vector(1 to b'length) := b;
        variable o_std : vector(1 to a'length);
    begin 
        assert a'length = b'length
            report "Incompatible length for elementwise and"
            severity error;
        for i in o_std'range loop
            o_std(i) := a_std(i) and b_std(i);
        end loop;
        return o_std;
    end function;

	function "or"  (a, b : vector) return vector is 
        variable a_std : vector(1 to a'length) := a;
        variable b_std : vector(1 to b'length) := b;
        variable o_std : vector(1 to a'length);
    begin 
        assert a'length = b'length
            report "Incompatible length for elementwise or"
            severity error;
        for i in o_std'range loop
            o_std(i) := a_std(i) or b_std(i);
        end loop;
        return o_std;
    end function;

	function "xor" (a, b : vector) return vector is 
        variable a_std : vector(1 to a'length) := a;
        variable b_std : vector(1 to b'length) := b;
        variable o_std : vector(1 to a'length);
    begin 
        assert a'length = b'length
            report "Incompatible length for elementwise xor"
            severity error;
        for i in o_std'range loop
            o_std(i) := a_std(i) xor b_std(i);
        end loop;
        return o_std;
    end function;

	function "nand"(a, b : vector) return vector is 
        variable a_std : vector(1 to a'length) := a;
        variable b_std : vector(1 to b'length) := b;
        variable o_std : vector(1 to a'length);
    begin 
        assert a'length = b'length
            report "Incompatible length for elementwise nand"
            severity error;
        for i in o_std'range loop
            o_std(i) := a_std(i) nand b_std(i);
        end loop;
        return o_std;
    end function;

	function "nor" (a, b : vector) return vector is 
        variable a_std : vector(1 to a'length) := a;
        variable b_std : vector(1 to b'length) := b;
        variable o_std : vector(1 to a'length);
    begin 
        assert a'length = b'length
            report "Incompatible length for elementwise nor"
            severity error;
        for i in o_std'range loop
            o_std(i) := a_std(i) nor b_std(i);
        end loop;
        return o_std;
    end function;

	function "xnor"(a, b : vector) return vector is 
        variable a_std : vector(1 to a'length) := a;
        variable b_std : vector(1 to b'length) := b;
        variable o_std : vector(1 to a'length);
    begin 
        assert a'length = b'length
            report "Incompatible length for elementwise xnor"
            severity error;
        for i in o_std'range loop
            o_std(i) := a_std(i) xnor b_std(i);
        end loop;
        return o_std;
    end function;

    --   == SCALAR MULTIPLICATION WITH GF2 ==
    function "*"   (a: std_logic; b: vector) return vector is 
        variable o_std : vector(1 to b'length) := b;
    begin
        for i in o_std'range loop 
            o_std(i) := o_std(i) * a;
        end loop;
        return o_std;
    end function;

    function "*"   (a: vector; b: std_logic) return vector is
    begin 
        return b * a;
    end function;

    -- function "."   (a: std_logic; b: vector) return vector is
    -- begin 
    --     return a * b;
    -- end function;

    -- function "."   (a: vector; b: std_logic) return vector is
    -- begin 
    --     return b * a;
    -- end function;

    --   == SCALAR MULTIPLICATION WITH Z ==
    function "*"   (a: integer; b: vector) return vector is 
    begin 
        return (mod2(a)) * b;
    end function;

    function "*"   (a: vector; b: integer) return vector is
    begin 
        return (mod2(b)) * a;
    end function;

    -- function "."   (a: integer; b: vector) return vector is
    -- begin 
    --     return (mod2(a)) * b;
    -- end function;

    -- function "."   (a: vector; b: integer) return vector; 
    -- begin 
    --     return (mod2(b)) * a;
    -- end function;

    --   == DOT PRODUCT ==
    function "*"   (a, b: vector) return std_logic is
        variable a_std: vector(1 to a'length) := a;
        variable b_std: vector(1 to b'length) := b;
        variable o: std_logic := '0';
    begin 
        assert a'length = b'length
            report "Cannot perform dot product on vectors of different lengths."
            severity error;
        for i in a_std'range loop
            o := o + (a_std(i) * b_std(i));
        end loop;
        return o;
    end function;

    -- function "dot" (a, b: vector) return std_logic is 
    -- begin 
    --     return a * b;
    -- end function;

    -- function "."   (a, b: vector) return std_logic is 
    -- begin 
    --     return a * b;
    -- end function;

    --   == OUTER PRODUCT ==
    function "**"   (a, b: vector) return matrix is 
        variable a_std: vector(1 to a'length) := a;
        variable b_std: vector(1 to b'length) := b;
        variable m_std: matrix(1 to a'length, 1 to b'length);
    begin 
        for i in m_std'range(1) loop
            for j in m_std'range(2) loop
                m_std(i, j) := a_std(i) * b_std(j);
            end loop;
        end loop;
    end function;


    --   ======================
    --   == Matrix Operators ==
    --   ======================
    --   == BITWISE OPERATIONS ==
    function "+"   (a, b : matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    begin 
        assert a'length(1) = b'length(1) and a'length(2) = b'length(2)
            report "Incompatible matrix sizes for elementwise addition"
            severity error;
        for i in o_std'range(1) loop
            for j in o_std'range(2) loop
                o_std(i, j) := a_std(i, j) + b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

    -- function "*"   (a, b : matrix) return matrix is -- JUST USE AND, * IS BETTER RESERVED FOR DOT PRODUCT
    --     variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
    --     variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
    --     variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    -- begin 
    --     assert a'length(1) = b'length(1) and a'length(2) = b'length(2)
    --         report "Incompatible matrix sizes for elementwise multiplication"
    --         severity error;
    --     for i in o_std'range(1) loop
    --         for j in o_std'range(1) loop
    --             o_std(i, j) := a_std(i, j) * b_std(i, j);
    --         end loop;
    --     end loop;
    --     return o_std;
    -- end function;

    -- function "^"   (a, b : matrix) return matrix is
    -- begin 
    --     return a + b;
    -- end function;

	-- function "!"   (a    : matrix) return matrix is
    --     variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
    --     variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    -- begin 
    --     for i in o_std'range(1) loop
    --         for j in o_std'range(2) loop
    --             o_std(i, j) := !a_std(i, j);
    --         end loop;
    --     end loop;
    --     return o_std;
    -- end function;

	function "not" (a    : matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    begin 
        for i in o_std'range(1) loop
            for j in o_std'range(2) loop
                o_std(i, j) := not a_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

	function "and" (a, b : matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    begin 
        assert a'length(1) = b'length(1) and a'length(2) = b'length(2)
            report "Incompatible matrix sizes for elementwise and"
            severity error;
        for i in o_std'range(1) loop
            for j in o_std'range(1) loop
                o_std(i, j) := a_std(i, j) and b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

	function "or"  (a, b : matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    begin 
        assert a'length(1) = b'length(1) and a'length(2) = b'length(2)
            report "Incompatible matrix sizes for elementwise or"
            severity error;
        for i in o_std'range(1) loop
            for j in o_std'range(1) loop
                o_std(i, j) := a_std(i, j) or b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

	function "xor" (a, b : matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    begin 
        assert a'length(1) = b'length(1) and a'length(2) = b'length(2)
            report "Incompatible matrix sizes for elementwise xor"
            severity error;
        for i in o_std'range(1) loop
            for j in o_std'range(1) loop
                o_std(i, j) := a_std(i, j) xor b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

	function "nand"(a, b : matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    begin 
        assert a'length(1) = b'length(1) and a'length(2) = b'length(2)
            report "Incompatible matrix sizes for elementwise nand"
            severity error;
        for i in o_std'range(1) loop
            for j in o_std'range(1) loop
                o_std(i, j) := a_std(i, j) nand b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

	function "nor" (a, b : matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    begin 
        assert a'length(1) = b'length(1) and a'length(2) = b'length(2)
            report "Incompatible matrix sizes for elementwise nor"
            severity error;
        for i in o_std'range(1) loop
            for j in o_std'range(1) loop
                o_std(i, j) := a_std(i, j) nor b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

	function "xnor"(a, b : matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2));
    begin 
        assert a'length(1) = b'length(1) and a'length(2) = b'length(2)
            report "Incompatible matrix sizes for elementwise xnor"
            severity error;
        for i in o_std'range(1) loop
            for j in o_std'range(1) loop
                o_std(i, j) := a_std(i, j) xnor b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

    --   == SCALAR MULTIPLICATION WITH GF2 ==
    function "*"   (a: std_logic; b: matrix) return matrix is 
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to b'length(1), 1 to b'length(2));
    begin 
        for i in o_std'range(1) loop
            for j in o_std'range(2) loop
                o_std(i, j) := a * b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

    function "*"   (a: matrix; b: std_logic) return matrix is 
    begin 
        return b * a;
    end function;

    -- function "."   (a: std_logic; b: matrix) return matrix is 
    -- begin 
    --     return a * b;
    -- end function;

    -- function "."   (a: matrix; b: std_logic) return matrix is
    -- begin 
    --     return b * a;
    -- end function;

    --   == SCALAR MULTIPLICATION WITH Z ==
    function "*"   (a: integer; b: matrix) return matrix is 
    begin 
        return (mod2(a)) * b;
    end function;

    function "*"   (a: matrix; b: integer) return matrix is 
    begin 
        return (mod2(b)) * a;
    end function;

    -- function "."   (a: integer; b: vector) return vector is 
    -- begin
    --     return (mod2(a)) * b;
    -- end function;

    -- function "."   (a: vector; b: integer) return vector is 
    -- begin 
    --     return (mod2(b)) * a;
    -- end function;

    --   == MATRIX PRODUCT (dot product) ==
    function "*"   (a, b: matrix) return matrix is 
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to b'length(2));
    begin 
        assert a'length(2) = b'length(1)
            report "Incompatible matrix sizes for matrix product"
            severity error;
        for i in o_std'range(1) loop
            for j in o_std'range(2) loop
                o_std(i, j) := '0';
                for r in a_std'range(2) loop
                    o_std(i, j) := o_std(i, j) + (a_std(i, r) * b_std(r, j));
                end loop;
            end loop;
        end loop;
        return o_std;
    end function;
        
    -- function "dot" (a, b: matrix) return matrix is 
    -- begin 
    --     return a * b;
    -- end function;

    -- function "."   (a, b: matrix) return matrix is 
    -- begin 
    --     return a * b;
    -- end function;

    --   == MATRIX PRODUCT WITH VECTOR (dot product) ==
    function "*"   (a: vector; b: matrix) return vector is 
        variable a_std: vector(1 to a'length) := a;
        variable b_std: matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std: vector(1 to b'length(2));
    begin 
        assert a_std'length = b_std'length(1)
            report "Incompatible dimensions for matrix multiplication"
            severity error;
        for i in o_std'range loop
            o_std(i) := '0';
            for r in a_std'range loop
                o_std(i) := o_std(i) + (a_std(r) * b_std(r, i));
            end loop;
        end loop;
        return o_std;
    end function;

    -- function "dot" (a: vector; b: matrix) return vector is 
    -- begin 
    --     return a * b;
    -- end function;

    -- function "."   (a: vector; b: matrix) return vector is 
    -- begin 
    --     return a * b;
    -- end function;

    function "*"   (a: matrix; b: vector) return vector is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a; 
        variable b_std: vector(1 to b'length) := b;
        variable o_std: vector(1 to b'length);
    begin 
        assert a_std'length(2) = b_std'length;
            report "Incompatible dimensions for matrix multiplication"
            severity error;
        for i in o_std'range loop
            o_std(i) := '0';
            for r in a_std'range loop
                o_std(i) := o_std(i) + (a_std(i, r) * b_std(r));
            end loop;
        end loop;
        return o_std;
    end function;

    -- function "dot" (a: matrix; b: vector) return vector is 
    -- begin 
    --     return a * b;
    -- end function;

    -- function "."   (a: matrix; b: vector) return vector is 
    -- begin 
    --     return a * b;
    -- end function;

    --   == KRONECKER PRODUCT (outer product) ==
    function "**"   (a, b: matrix) return matrix is 
        variable a_std : matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std : matrix(1 to b'length(1), 1 to b'length(2)) := b;
        variable o_std : matrix(1 to a'length(1) * b'length(1), 1 to a'length(2) * b'length(2));
    begin 
        for m in a_std'range(1) loop
            for n in a_std'range(2) loop 
                for p in b_std'range(1) loop 
                    for q in b_std'range(2) loop
                        o_std(m * p, n * q) := a_std(m, n) * b_std(p, q);
                    end loop;
                end loop;
            end loop;
        end loop;
        return o_std;
    end function;

    --   ============================
    --   == Other Matrix Operators ==
    --   ============================

    function "&" (a, b: matrix) return matrix is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable b_std: matrix(1 to b'length(1), a'length(2) + 1 to a'length(2) + b'length(2)) := b;
        variable o_std: matrix(1 to a'length(1), 1 to a'length(2) + b'length(2));
    begin 
        assert a'length(1) = b'length(1)
            report "Incompatible sizes for matrix concatenation"
            severity error;
        
        for i in a_std'range(1) loop
            for j in a_std'range(2) loop
                o_std(i, j) := a_std(i, j);
            end loop;
        end loop;

        for i in b_std'range(1) loop
            for j in b_std'range(2) loop
                o_std(i, j) := b_std(i, j);
            end loop;
        end loop;
        return o_std;
    end function;

    function "&" (a: matrix; b: vector) return matrix is
    begin 
        return a & column(b);
    end function;

    function "&" (a: vector; b: matrix) return matrix is 
    begin 
        return column(a) & b;
    end function;



    ------------------------------
    -- FUNCTION IMPLEMENTATIONS --
    ------------------------------    
    
    --   ==========================
    --   == Assignment Functions ==
    --   ==========================
    function zeros(n: integer) return vector is 
        variable o_std: vector(1 to n) := (others => '0');
    begin 
        return o_std;
    end function;

    function zeros(m, n: integer) return matrix is
        variable o_std: matrix(1 to m, 1 to n) := (others => (others => '0'));
    begin 
        return o_std;
    end function;

    function zeros(s: tuple) return matrix is 
    begin 
        return zeros(s(1), s(2));
    end function;

    function ones(n: integer) return vector is 
        variable o_std: vector(1 to n) := (others => '1');
    begin 
        return o_std;
    end function;

    function ones(m, n: integer) return matrix  is
        variable o_std: matrix(1 to m, 1 to n) := (others => (others => '1'));
    begin 
        return o_std;
    end function;

    function ones(s: tuple) return matrix is
    begin 
        return ones(s(1), s(2));
    end function;

    function identity(n: integer) return matrix is 
        variable o_std: matrix(1 to n, 1 to n) := (others => (others => '0'));
    begin 
        for i in 1 to n loop
            o_std(i, i) := '1';
        end loop;
        return o_std;
    end function;

    function column(a: vector) return matrix is 
        variable a_std: vector(1 to a'length) := a;
        variable o_std: matrix(1 to a'length, 1 to 1);
    begin 
        for i in a_std'range loop
            o_std(i, 1) := a_std(i);
        end loop;
        return o_std;
    end function;

    function row(a: vector) return matrix is 
        variable a_std: vector(1 to a'length) := a;
        variable o_std: matrix(1 to 1, 1 to a'length);
    begin 
        for i in a_std'range loop
            o_std(1, i) := a_std(i);
        end loop;
        return o_std;
    end function;


    --   ==========================
    --   == Conversion functions ==
    --   ==========================
    function to_logic_vector(a: vector) return std_logic_vector is 
        variable a_std: vector(1 to a'length) := a;
        variable o_std: std_logic_vector(1 to a'length);
    begin 
        for i in a_std'range loop
            o_std(i) := a_std(i);
        end loop;
        return o_std;
    end function;

    function to_vector(a: std_logic_vector) return vector is
        variable a_std: std_logic_vector(1 to a'length) := a;
        variable o_std: vector(1 to a'length);
    begin 
        for i in a_std'range loop
            o_std(i) := a_std(i);
        end loop;
        return o_std;
    end function;

    function mod2(a: integer) return std_logic is
    begin
        if a mod 2 = 0 then
            return '0';
        else 
            return '1';
        end if;
    end function;

    --   =======================
    --   == Matrix Properties ==
    --   =======================
    function size(a: vector) return integer is 
    begin 
        return a'length;
    end function;

    function size(a: matrix) return tuple is 
    begin 
        return tuple'(a'length(1), a'length(2));
    end function;
    
    function iscolumn(a: matrix) return boolean is 
    begin 
        return a'length(2) = 1;
    end function;

    function isrow(a: matrix) return boolean is 
    begin 
        return a'length(1) = 1;
    end function;

    function issquare(a: matrix) return boolean is 
    begin 
        return a'length(1) = a'length(2);
    end function;

    function issingular(a: matrix) return boolean is 
    begin 
        return iscolumn(a) and isrow(a);
    end function;


    --   =======================
    --   == Slicing Functions ==
    --   =======================
    function getrow(a: matrix; n: integer) return vector is 
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable o_std: vector(1 to a'length(2));
    begin 
        assert (n > 0) and (n < a'length(1) + 1)
            report "Cannot get row " & integer'image(n) & " of matrix. Index out of bounds"
            severity error;
        
        for i in o_std'range loop
            o_std(i) := a_std(n, i);
        end loop;
        return o_std;
    end function;

    function getcolumn(a: matrix; n: integer) return vector is
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable o_std: vector(1 to a'length(1));
    begin 
        assert (n > 0) and (n < a'length(2) + 1)
            report "Cannot get column " & integer'image(n) & " of matrix. Index out of bounds"
            severity error;
        
        for i in o_std'range loop
            o_std(i) := a_std(i, n);
        end loop;
        return o_std;
    end function;



    --   ===========================
    --   == Utilities and Aliases ==
    --   ===========================
    function transpose(a: matrix) return matrix is 
        variable a_std: matrix(1 to a'length(1), 1 to a'length(2)) := a;
        variable o_std: matrix(1 to a'length(2), 1 to a'length(1));
    begin 
        for i in o_std'range(1) loop
            for j in o_std'range(2) loop
                o_std(i, j) := a_std(j, i);
            end loop;
        end loop;
        return o_std;
    end function;

    function transpose(a: vector) return vector is
        variable a_std: vector(1 to a'length) := a;
    begin 
        return a_std;
    end function;

    function transpose(a: std_logic) return std_logic is 
    begin 
        return a;
    end function;

    function concat(a, b: matrix) return matrix is 
    begin 
        return a & b;
    end function;

    function concat_identity_left(m: matrix) return matrix is
    begin 
        return identity(m'length(1)) & m;
    end function;

    function concat_identity_right(m: matrix) return matrix is 
    begin 
        return m & identity(m'length(1));
    end function;

    function dot(a, b: vector) return std_logic is 
    begin 
        return a * b;
    end function;

    function dot(a: vector; b: matrix) return vector is 
    begin 
        return a * b;
    end function;

    function dot(a: matrix; b: vector) return vector is 
    begin 
        return a * b;
    end function;

    function dot(a, b: matrix) return matrix is 
    begin 
        return a * b;
    end function;

    --   ======================
    --   == String functions ==
    --   ======================
    function to_string(a: matrix) return string  is
        variable v  : vector(a'range(2));
        variable buf: line;
    begin         
        for i in a'range(1) loop 
            for j in a'range(2) loop 
                v(j) := a(i, j); 
            end loop;
            write(buf, to_string(v));

            if i /= a'range(1)'right then
                write(buf, string'("") & LF);
            end if;
        end loop;
        return buf.all;
    end function;

    function to_string(a: vector) return string is 
        variable buf: line;
    begin
        write(buf, string'("[ "));
        for i in a'range loop 
            write(buf, pkg_matrix_to_string(a(i)) & " ");
        end loop;
        write(buf, string'("]"));
        return buf.all;
    end function;

    function to_string(a: tuple) return string is 
        variable bfr: line;
    begin 
        write(bfr, string'("(" & integer'image(a(1)) & "," & integer'image(a(2)) & ")"));
    end function to_string;

    function to_string(a: std_logic_vector) return string is 
    begin 
        return to_string(to_vector(a));
    end function;

    function to_string(v: intvec_t) return string is
        variable bfr: line;
    begin 
        write(bfr, string'("( "));
        for i in v'range loop
            write(bfr, integer'image(v(i)));
            write(bfr, string'(" "));
        end loop;
        write(bfr, string'(")"));
        return bfr.all;
    end function to_string;

    function pkg_matrix_to_string(a: std_logic) return string is
        variable c: string(1 downto 1);
    begin 
        case a is  
            when '1' => c := "1";
            when '0' => c := "0";
            when 'H' => c := "H";
            when 'L' => c := "L";
            when 'Z' => c := "Z";
            when 'W' => c := "W";
            when 'X' => c := "X";
            when 'U' => c := "U";
            when '-' => c := "-";
            when others => c := "?";
        end case;
        return c;
    end function;
  
end package body vectors;