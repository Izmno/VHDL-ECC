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
-- File Name:       unittest_hamming.vhdl
-- File Type:       VHDL Package
--
-- Create Date:     14 feb 2021
-- Design Name:     unittest_hamming
-- Module Name:     unittest_hamming
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
--   Package overloads of the run_test procedure in the unittest package
--   for datatypes of the package `hamming`. More specifically:
--   run_test(testrun_t, string, string, hamming_t, hamming_t) and
--   run_test(testrun_t, string, string, intvec_t, intvec_t)
--
-- Dependencies:
--   - pkg_hamming
--   - unittest
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
library work;
use work.hamming.all;
use work.vectors.all;
use work.unittest.all;

---------------------------------
-- UNITTEST_HAMMING            --
---------------------------------
package unittest_hamming is
    -----------------------------
    -- PROCEDURE PROTOTYPES    --
    -----------------------------
    -- Description in body     --
    -----------------------------
    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in hamming_t; result: in hamming_t);
    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in intvec_t; result: in intvec_t);
end package unittest_hamming;

---------------------------------
-- UNITTEST_MATRIX BODY        --
---------------------------------
package body unittest_hamming is
    -----------------------------
    -- PROCEDURE BODIES        --
    -----------------------------
    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in hamming_t; result: in hamming_t) is 
    begin 
        start_test(run, name, description, to_string(expected), to_string(result));
        finish_test(run, expected = result);
    end procedure run_test;

    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in intvec_t; result: in intvec_t) is
    begin 
        start_test(run, name, description, to_string(expected), to_string(result));
        finish_test(run, expected = result);
    end procedure run_test;

end package body unittest_hamming;

     