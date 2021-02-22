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
-- File Name:       combinations.vhdl
-- File Type:       VHDL Package
--
-- Create Date:     22 feb 2021
-- Design Name:     combinations
-- Module Name:     combinations
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
--    Package provides functions for dealing with combinations (take k out of n)
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
use ieee.numeric_std.all;

library work;
use work.vectors.all;


package combinations is

    function factorial(n: natural) return natural;
    function factorial(n, d: natural) return natural; 
    function num_combinations(n, k: natural) return natural;

    function enumerate_combinations(n, k: natural) return intvec_t;
end package;

package body combinations is
    function factorial(n: natural) return natural is
    begin 
        return factorial(n, 0);
    end function;

    function factorial(n, d: natural) return natural is
        variable m: natural := n;
        variable o: natural := 1;
    begin 
        while m > d loop 
            o := o * m;
            m := m - 1;
        end loop;
        return o;
    end function;
    
    function num_combinations(n, k: natural) return natural is
        variable m: natural := n;
        variable i: natural := 1;
        variable o: natural := 1;
    begin 
        if k > n then
            assert false
                report "Cannot calculate number of combinations (n k) with k > n"
                severity error;
            return 1;
        elsif n - k > k then
            -- this is a bit quicker for large n, small k
            return num_combinations(n, n - k);
        else
            while m > n - k loop
                o := o * m;
                o := o / i;
                m := m - 1;
                i := i + 1;
            end loop;
            return o;
        end if;
    end function;


    function enumerate_combinations(n, k: natural) return intvec_t is
        variable length: integer := num_combinations(n, k);
        variable list: intvec_t(1 to length) := (others => 0);
        variable indices: intvec_t(0 to k);
        variable index_to_update: natural;
        variable found_index_to_update: boolean;
        variable current_combination: unsigned(n - 1 downto 0);
    begin 
        if k > n then
            assert false 
                report "Cannot calculate number of combinations (n k) with k > n"
                severity error;
            return list;
        elsif k = 0 then
            return list;
        else
            -- initialize indices
            for i in indices'range loop
                indices(i) := i;
            end loop;
            indices(k) := n;

            for num in list'range loop
                -- set current combination
                current_combination := (others => '0');
                for i in 0 to k - 1 loop
                    current_combination(indices(i)) := '1';
                end loop;
                -- add combination to list
                list(num) := to_integer(current_combination);
                -- update indices 
                -- step 1: find the bit to move
                found_index_to_update := false;
                index_to_update := k - 1;
                while index_to_update > 0 and found_index_to_update = false loop
                    if indices(index_to_update) + 1 < indices(index_to_update + 1) then
                        found_index_to_update := true;
                    else 
                        index_to_update := index_to_update - 1;
                    end if;
                end loop;
                -- step 2: move the bit, and move the others right next to it
                for i in index_to_update to k - 1 loop
                    if i = index_to_update then
                        indices(i) := indices(i) + 1;
                    else
                        indices(i) := indices(i - 1) + 1;
                    end if;
                end loop;
            end loop;

            return list;
        end if;
    end function;

end package body;
