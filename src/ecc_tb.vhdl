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
-- File Name:       ecc_tb.vhdl
-- File Type:       VHDL testbench
--
-- Create Date:     19 feb 2021
-- Design Name:     ecc_tb
-- Module Name:     ecc_tb
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
-- 
-- Dependencies:
--   - (ieee.std_logic_1164) 
--   - ecc_pkg
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
use ieee.math_real.uniform;
use ieee.math_real.round;

library work;
use work.ecc_pkg.all;
use work.biterror.all;

entity ecc_tb is
end entity ecc_tb;

architecture tb of ecc_tb is
    signal test_data: std_logic_vector(31 downto 0);
    signal data_corrected: std_logic_vector(31 downto 0);
    signal data_corrupted: std_logic_vector(31 downto 0);

    signal chkbits_encoded: std_logic_vector(6 downto 0);
    signal chkbits_corrupted: std_logic_vector(6 downto 0);

    signal stored_data: std_logic_vector(38 downto 0);
    signal stored_data_corrupted: std_logic_vector(38 downto 0);

    signal single_error: std_logic;
    signal double_error: std_logic;

    signal encode: std_logic := '1';

begin 
    -- component
    DUT_single_errors: ecc 
        generic map (
            g_data_bits         => 32,
            g_parity_bits       => 6,
            g_total_parity_bits => 7,
            g_extended          => true
        )
        port map (
            encode       => '0',
            correct      => '1',
            data_in      => test_data,
            chkbits_in   => chkbits_corrupted,
            data_out     => data_corrected,
            chkbits_out  => chkbits_encoded,
            single_error => single_error,
            double_error => double_error
        );

    -- signal mapping
    chkbits_corrupted <= stored_data_corrupted(6 downto 0);
    data_corrupted <= stored_data_corrupted(38 downto 7);
    stored_data <= data_corrected & chkbits_encoded;



    test_single_errors: process 
        variable seed1, seed2: integer := 999;
        variable randslv : std_logic_vector(31 downto 0);

        -- https://vhdlwhiz.com/random-numbers/
        impure function rand_slv(len : integer) return std_logic_vector is
            variable r : real;
            variable slv : std_logic_vector(len - 1 downto 0);
          begin
            for i in slv'range loop
                uniform(seed1, seed2, r);
                if r > 0.5 then 
                    slv(i) := '1';
                else
                    slv(i) := '0';
                end if;
            end loop;
            return slv;
          end function;

        impure function rand_int(min_val, max_val : integer) return integer is
            variable r : real;
        begin
            uniform(seed1, seed2, r);
            return integer(round(r * real(max_val - min_val + 1) + real(min_val) - 0.5));
        end function;
    begin 
        for iv in 1 to 10 loop
            randslv := rand_slv(32);

            test_data <= randslv;
            encode <= '1';
            wait for 10 ns;
            stored_data_corrupted <= flip_bit(stored_data, rand_int(0, 38));
            wait for 10 ns;
            test_data <= data_corrupted;
            encode <= '0';
            wait for 10 ns;

            if randslv = data_corrected then
                assert false 
                    report "PASS"
                    severity note;
            else 
                assert false
                    report "FAIL"
                    severity note;
            end if;
        end loop;

        wait;

    end process;

end architecture tb;