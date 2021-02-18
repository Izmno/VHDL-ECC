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
-- File Name:       spc.vhdl
-- File Type:       VHDL Package
--
-- Create Date:     17 feb 2021
-- Design Name:     spc
-- Module Name:     spc
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
--    Package provides functions for parity bit error detection
--
-- Dependencies:
--   - (ieee.std_logic_1164) 
--   - vectors
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

package spc is
    function spc_encode(data: vector) return vector;
    function spc_encode(data: std_logic_vector) return std_logic_vector;

    function spc_encode_chkbits(data: vector) return vector;
    function spc_encode_chkbits(data: std_logic_vector) return std_logic_vector;

    function spc_append_chkbits(data: vector; chkbits: vector) return vector;
    function spc_append_chkbits(data: std_logic_vector; chkbits: std_logic_vector) return std_logic_vector;

    function spc_syndrome(code: vector) return vector;
    function spc_syndrome(code: std_logic_vector) return std_logic_vector;
    function spc_syndrome(data: vector; chkbits: vector) return vector;
    function spc_syndrome(data: std_logic_vector; chkbits: std_logic_vector) return std_logic_vector;

    function spc_num_errors(syndrome: vector) return integer;
    function spc_num_errors(syndrome: std_logic_vector) return integer;

    -- simpler api
    function parity(data: vector) return std_logic;
    function parity(data: std_logic_vector) return std_logic;

    function add_parity_bit(data: vector) return vector;
    function add_parity_bit(data: std_logic_vector) return std_logic_vector;
end package spc;

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.vectors.all;

package body spc is 

    function spc_encode(data: vector) return vector is 
    begin
        return data * (identity(data'length) & ones(data'length));
    end function;

    function spc_encode(data: std_logic_vector) return std_logic_vector is 
    begin 
        return to_logic_vector(spc_encode(to_vector(data)));
    end function;

    function spc_encode_chkbits(data: vector) return vector is 
        variable o: vector(1 to 1);
    begin 
        o(1) := data * ones(data'length);
        return o;
    end function;

    function spc_encode_chkbits(data: std_logic_vector) return std_logic_vector is 
    begin 
        return to_logic_vector(spc_encode_chkbits(to_vector(data)));
    end function;

    function spc_append_chkbits(data: vector; chkbits: vector) return vector is
    begin 
        return data & chkbits;
    end function;

    function spc_append_chkbits(data: std_logic_vector; chkbits: std_logic_vector) return std_logic_vector is 
    begin 
        return data & chkbits;
    end function;

    function spc_syndrome(code: vector) return vector is 
        variable o: vector(1 to 1);
    begin 
        o(1) := code * ones(code'length);
        return o;
    end function;

    function spc_syndrome(code: std_logic_vector) return std_logic_vector is 
    begin
        return to_logic_vector(spc_syndrome(to_vector(code)));
    end function;

    function spc_syndrome(data: vector; chkbits: vector) return vector is
    begin 
        return spc_syndrome(spc_append_chkbits(data, chkbits));
    end function;

    function spc_syndrome(data: std_logic_vector; chkbits: std_logic_vector) return std_logic_vector is 
    begin 
        return spc_syndrome(spc_append_chkbits(data, chkbits));
    end function;

    function spc_num_errors(syndrome: vector) return integer is 
    begin 
        assert syndrome'length = 1 
            report "Incorrect syndrome length for SPC. Expected 1, got " & integer'image(syndrome'length) & "."
            severity error;
        if syndrome(1) = '0' then
            return 0;
        else 
            return 1;
        end if;
    end function;

    function spc_num_errors(syndrome: std_logic_vector) return integer is 
    begin 
        return spc_num_errors(to_vector(syndrome));
    end function;


    function parity(data: vector) return std_logic is
    begin 
        return data * ones(data'length);
    end function;

    function parity(data: std_logic_vector) return std_logic is 
    begin
        return to_vector(data) * ones(data'length);
    end function;

    function add_parity_bit(data: vector) return vector is 
    begin 
        return spc_encode(data);
    end function;

    function add_parity_bit(data: std_logic_vector) return std_logic_vector is
    begin 
        return spc_encode(data);
    end function;

end package body spc;
