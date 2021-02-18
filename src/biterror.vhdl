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
-- File Name:       biterror.vhdl
-- File Type:       VHDL Package
--
-- Create Date:     18 feb 2021
-- Design Name:     biterror
-- Module Name:     biterror
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
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

package biterror is 
    function flip_bit(v: vector; b: integer) return vector;
    function flip_bit(v: std_logic_vector; b: integer) return std_logic_vector;

    function flip_bit(v: vector; b: intvec_t) return vector;
    function flip_bit(v: std_logic_vector; b: intvec_t) return vector;
end package biterror;

package body biterror;
    function flip_bit(v: vector; b: integer) return vector is 
        variable v_std: vector(v'length - 1 downto 0) := v;
    begin 
        if b > v'length - 1 or b < 0 then
            assert false
                report "Bit index out of range. No bits are flipped."
                severity info;
        else 
            v_std(b) := not v_std(b);
        end if;
        return v_std;
    end function;

    function flip_bit(v: std_logic_vector; b: integer) return std_logic_vector;
    begin 
        return to_logic_vector(flip_bit(to_vector(v), b));
    end function;

    function flip_bit(v: vector; b: intvec_t) return vector is
        variable v_std(v'length - 1 downto 0) := v;
    begin 
        for i in b'range loop
            v_std := flip_bit(v_std, b(i));
        end loop;
        return v_std;
    end function;

    function flip_bit(v: std_logic_vector; b: intvec_t) return vector is 
    begin 
        return to_logic_vector(flip_bit(to_vector(v), b));
    end function;
end package body biterror;