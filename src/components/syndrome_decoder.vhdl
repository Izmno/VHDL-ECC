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
-- File Name:       syndrome_decoder.vhdl
-- File Type:       VHDL Component and Package
--
-- Create Date:     21 feb 2021
-- Design Name:     ecc
-- Module Name:     ecc
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
-- 
-- Dependencies:
--   - (ieee.std_logic_1164) 
--   - (ieee.numeric_std)
--   - (std.textio)
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
use ieee.numeric_std.all;

library std;
use std.textio.all;

library work;
use work.hamming.all;

package syndrome_decoder_pkg is
    component syndrome_decoder is 
        generic (
            -- number of data bits
            g_data_bits: integer := 32;

            -- should always be hamming.calc_parity_bits(g_data_bits)
            g_parity_bits: integer := 6;
            
            -- should always be g_parity_bits + 1 if g_extended else g_parity_bits
            g_total_parity_bits: integer := 7;
            
            -- whether to use extended hamming codes
            g_extended: boolean := true
        );
        port (
            code         : in  std_logic_vector(g_total_parity_bits + g_data_bits - 1 downto 0);
            syndrome     : out  std_logic_vector(g_total_parity_bits - 1 downto 0)
        );
    end component syndrome_decoder;
end package syndrome_decoder_pkg;

package body syndrome_decoder_pkg is
end package body syndrome_decoder_pkg;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library work;
use work.hamming.all;
use work.syndrome_decoder_pkg.all;

entity syndrome_decoder is 
generic (
    -- number of data bits
    g_data_bits: integer := 32;

    -- should always be hamming.calc_parity_bits(g_data_bits)
    g_parity_bits: integer := 6;
    
    -- should always be g_parity_bits + 1 if g_extended else g_parity_bits
    g_total_parity_bits: integer := 7;
    
    -- whether to use extended hamming codes
    g_extended: boolean := true
);
port (
    code         : in  std_logic_vector(g_total_parity_bits + g_data_bits - 1 downto 0);
    syndrome     : out  std_logic_vector(g_total_parity_bits - 1 downto 0)
);
end entity syndrome_decoder;

architecture behaviour of syndrome_decoder is
    -- hamming properties 
    constant hamming: hamming_t := init_hamming(g_data_bits, g_extended);    
begin 
    syndrome <= hamming_syndrome(hamming, code);
end architecture;
