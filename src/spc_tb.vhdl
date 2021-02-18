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
-- File Name:       spc_tb.vhdl
-- File Type:       VHDL Testbench
--
-- Create Date:     17 feb 2021
-- Design Name:     spc_tb
-- Module Name:     spc_tb
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
--    Testbench for SPC package
--
-- Dependencies:
--   - (ieee.std_logic_1164) 
--   - vectors
--   - unittest
--   - unittest_vectors
--   - spc
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

library work;
use work.vectors.all;
use work.spc.all;
use work.unittest.all;
use work.unittest_vectors.all;

entity spc_tb is 
end entity spc_tb;

architecture tb of spc_tb is
begin 
    process
        variable run: testrun_t := create_run(
            "SPC Unittests", 
            "Basic unittests for all functions in the SPC package"
        ); 
    begin 

        run_test(
            run,
            "spc_encode(vector)",
            "Encode a sample data vector",
            vector'("100100"),
            spc_encode(vector'("10010"))
        );

        run_test(
            run,
            "spc_encode(std_logic_vector)",
            "Encode a sample data vector",
            std_logic_vector'("1110001"),
            spc_encode(std_logic_vector'("111000"))
        );

        run_test(
            run, 
            "spc_encode_chkbits(vector)",
            "Get the checkbits of a sample data vector",
            vector'("0"),
            spc_encode_chkbits(vector'("10010"))
        );

        run_test(
            run, 
            "spc_encode_chkbits(std_logic_vector)",
            "Get the checkbits of a sample data vector",
            std_logic_vector'("1"),
            spc_encode_chkbits(std_logic_vector'("111000"))
        );

        run_test(
            run, 
            "spc_append_chkbits(vector, vector)",
            "",
            vector'("010"),
            spc_append_chkbits(vector'("01"), vector'("0"))
        );
  
        run_test(
            run,
            "spc_syndrome(vector)",
            "Get syndrome of encoded vector",
            vector'("0"),
            spc_syndrome(spc_encode("0101"))
        );

        run_test(
            run,
            "spc_syndrome(vector)",
            "Get syndrome of vector with bit error",
            vector'("1"),
            spc_syndrome(vector'("01011"))
        );

        wait;
    end process;
end architecture tb;