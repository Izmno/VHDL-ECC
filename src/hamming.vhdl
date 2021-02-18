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
-- File Name:       hamming.vhdl
-- File Type:       VHDL Package
--
-- Create Date:     11 feb 2021
-- Design Name:     hamming
-- Module Name:     hamming
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
--   encode overloads which specify number of data bits on output
--   do not work as intended
-- 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library work;
use work.vectors.all;

package hamming is
     -----------------------------
     -- TYPE DEFINITIONS
     -----------------------------

     -- hamming_t
     -- 
     -- Base type for the parameters of a hamming code
     type hamming_t is record 
          parity_bits: integer;
          total_parity_bits: integer;
          max_data_bits: integer;
          max_total_bits: integer;
          data_bits: integer;
          total_bits: integer;
          extended: boolean;
     end record hamming_t;

     -- intvec_t
     -- 
     -- Integer vector type
     type intvec_t is array ( integer range <> ) of integer;

     -----------------------------
     -- FUNCTION PROTOTYPES
     -----------------------------

     function to_string(h: hamming_t) return string;
     function to_string(v: intvec_t) return string;

     function cond_increment(i: integer; c: boolean) return integer;

     function calc_data_bits(parity_bits: integer range 2 to integer'high) return integer;
     function calc_parity_bits(data_bits: integer) return integer;

     function init_hamming(data_bits: integer; extended: boolean) return hamming_t;

     function calc_nonpower(limit: integer) return intvec_t;
     function positions(hamming: hamming_t) return intvec_t;

     function base_matrix(p: integer; e: boolean) return matrix;
     function base_matrix(hamming: hamming_t) return matrix;
     function generator_matrix(p: integer; e: boolean) return matrix;
     function generator_matrix(hamming: hamming_t) return matrix;
     function parity_check_matrix(p: integer; e: boolean) return matrix;
     function parity_check_matrix(hamming: hamming_t) return matrix;

     function encode(gen_matrix: matrix; data: std_logic_vector) return std_logic_vector;
     function encode(p: integer; e: boolean; data: std_logic_vector) return std_logic_vector;
     function encode(hamming: hamming_t; data: std_logic_vector) return std_logic_vector;
     function encode(gen_matrix: matrix; d: integer; data: std_logic_vector) return std_logic_vector;
     function encode(p: integer; d: integer; e: boolean; data: std_logic_vector) return std_logic_vector;

     -- function encode_chkbits(gen_matrix: matrix; data: std_logic_vector) return std_logic_vector;
     -- function encode_chkbits(p: integer; e: boolean; data: std_logic_vector) return std_logic_vector;
     -- function encode_chkbits(hamming: hamming_t; data: std_logic_vector) return std_logic_vector;

     -- function syndrome(p_check_matrix: matrix; data: std_logic_vector) return std_logic_vector;
     -- function syndrome(p: integer; e: boolean; data: std_logic_vector) return std_logic_vector;
     -- function syndrome(hamming: hamming_t; data: std_logic_vector) return std_logic_vector;

     -- function syndrome_chkbits(p_check_matrix: matrix; data: std_logic_vector) return std_logic_vector;
     -- function syndrome_chkbits(p: integer; e: boolean; data: std_logic_vector) return std_logic_vector;
     -- function syndrome_chkbits(hamming: hamming_t; data: std_logic_vector) return std_logic_vector;

     -- function get_num_errors(syndrome: std_logic_vector; e: boolean) return integer;
     -- function get_num_errors(syndrome: std_logic_vector; h: hamming_t) return integer;
     -- function single_bit_error(syndrome: std_logic_vector; e: boolean) return boolean;
     -- function single_bit_error(syndrome: std_logic_vector; e: hamming_t) return boolean;
     -- function double_bit_error(syndrome: std_logic_vector; e: boolean) return boolean;
     -- function double_bit_error(syndrome: std_logic_vector; e: hamming_t) return boolean;

     -- function get_error_index(syndrome: std_logic_vector; e: boolean) return integer;
     -- function get_error_index(syndrome: std_logic_vector; h: hamming_t) return integer;

     -- function get_error_mask(index: integer; d: integer) return std_logic_vector;
     -- function get_error_mask(syndrome: std_logic_vector; e: boolean; d: integer) return std_logic_vector;
     -- function get_error_mask(syndrome: std_logic_vector; e: boolean; h: hamming_t) return std_logic_vector;

end hamming;

package body hamming is

     -- to_string 
     -- 
     -- Utility function which returns a string representation of a 
     -- hamming type object. 
     --
     -- @param h: hamming_t: the object to turn into a string 
     -- @returns string: the string representation
     function to_string(h: hamming_t) return string is 
          variable bfr: line;
     begin 
          write(bfr, string'("{") & LF);
          write(bfr, string'(" parity bits: "));
          write(bfr, integer'image(h.parity_bits) & LF);
          write(bfr, string'(" total parity bits: "));
          write(bfr, integer'image(h.total_parity_bits) & LF);
          write(bfr, string'(" max data bits: "));
          write(bfr, integer'image(h.max_data_bits) & LF);
          write(bfr, string'(" max total bits: "));
          write(bfr, integer'image(h.max_total_bits) & LF);
          write(bfr, string'(" data bits: "));
          write(bfr, integer'image(h.data_bits) & LF);
          write(bfr, string'(" total bits: "));
          write(bfr, integer'image(h.total_bits) & LF);
          write(bfr, string'(" extended: "));
          write(bfr, boolean'image(h.extended) & LF);
          write(bfr, string'("}"));
          return bfr.all;
     end function to_string;

     -- to_string 
     -- 
     -- Utility function which returns a string representation of a 
     -- integer vector type object. 
     --
     -- @param v: intvec_t: the object to turn into a string 
     -- @returns string: the string representation
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

     -- cond_increment
     --
     -- silly function which returns an integer 1 higher than the 
     -- supplied integer if a condition is met, otherwise it returns the 
     -- integer itself.
     function cond_increment(i: integer; c: boolean) return integer is 
     begin 
          if c then
               return i + 1;
          else 
               return i;
          end if;
     end function cond_increment;
     

     -- calc_data_bits
     --
     -- Calculates the maximum number of data bits available for the given 
     -- parity bits. Excludes the extra parity bit of extended hamming codes
     --
     -- @param parity_bits: integer: the amount of parity bits
     -- @returns integer: the number of data bits available
     function calc_data_bits(parity_bits: integer range 2 to integer'high) return integer is
     begin
          return 2 ** parity_bits - parity_bits - 1;
     end function calc_data_bits;
   
     -- calc_parity_bits
     -- 
     -- Calculates the number of parity bits necessary for a given data width
     -- Excludes the extra parity bit of extended hamming codes
     --
     -- @param data_bits: integer: the width of the data to be encoded
     -- @returns integer: the number of parity bits necessary for the hamming code
     function calc_parity_bits(data_bits: integer) return integer is
          variable m: integer := 2; -- number of parity bits
          variable k: integer := calc_data_bits(m); -- number of data bits
     begin
          while (k < data_bits) loop
               m := m + 1;
               k := calc_data_bits(m);
          end loop;
          return m;
     end function calc_parity_bits;

     -- init_hamming
     --
     -- Initialization function for the parameters of a Hamming code 
     -- 
     -- @param data_bits: integer: the number of data bits to be encoded
     -- @param extended: boolean: whether to use an extra parity bit 
     -- @returns hamming_t: the parameters of the hamming code
     function init_hamming(data_bits: integer; extended: boolean) return hamming_t is 
          variable parity_bits: integer;
          variable total_parity_bits: integer;
          variable max_data_bits: integer;
          variable max_total_bits: integer;
          variable total_bits: integer;
          variable h: hamming_t;
     begin 
          parity_bits := calc_parity_bits(data_bits);
          total_parity_bits := cond_increment(parity_bits, extended);
          max_data_bits := calc_data_bits(parity_bits);
          total_bits := total_parity_bits + data_bits;
          max_total_bits := total_parity_bits + max_data_bits;

          h := (
               parity_bits => parity_bits,
               total_parity_bits => total_parity_bits,
               max_data_bits => max_data_bits,
               max_total_bits => max_total_bits,
               data_bits => data_bits,
               total_bits => total_bits,
               extended => extended
          );
          return h;          
     end function init_hamming;

     -- calc_nonpower
     --
     -- Calculate a vector of all integers smaller than 2 ** limit which
     -- are not a power of 2. MSB is the lowest integer (3).
     -- 
     -- The number of integers which satisfy this condition is always 
     -- equal to 2 ** limit - limit - 1, which corresponds to the number 
     -- of data bits available in a hamming code of 'limit' parity bits
     --  
     -- @asserts error: if limit < 2
     --
     -- @param limit: integer: the 2log of the limit to the vector
     -- @returns intvec_t: the vector of integers
     function calc_nonpower(limit: integer) return intvec_t is 
          variable length: integer := calc_data_bits(limit);
          variable power: integer := 1;
          variable vec: intvec_t(length - 1 downto 0);
          variable idx: integer := vec'range'left;
     begin
          -- Limits lower than 2 are not allowed. 
          -- This would result in an empty list. Cannot be bothered
          -- to foolproof the rest of the code against this. 
          assert limit > 1
               report "Invalid parameter for calc_nonpower(integer): " 
                    & integer'image(limit)
               severity error;
          
          -- just go over all integers, filter the powers of 2
          for i in 1 to 2 ** limit loop
               -- keep track of the lowest power of 2 > i
               while power < i loop 
                    power := power * 2;
               end loop;
               -- if i is not a power of 2, put it in the list
               if i /= power then 
                    vec(idx) := i;
                    idx := idx - 1;
               end if;
          end loop;
          return vec;
     end function calc_nonpower;

     -- positions
     --
     -- Calculate a vector of all positions of the data bits in a 
     -- hamming code. Positions are 1-indexed.
     -- These positions correspond to all non-power-of-2 indices.
     -- 
     -- The total amount of positions (or total bits of a hamming code)
     -- is equal to 2 ** parity bits - parity bits - 1.
     --  
     -- @asserts error: if parity bits < 2
     -- @param hamming: hamming_t: the hamming code for which to calculate
     -- the positions of the data bits
     -- @returns intvec_t: the vector of positions
     function positions(hamming: hamming_t) return intvec_t is
     begin
          return calc_nonpower(hamming.parity_bits);
     end function positions;

     -- base_matrix
     -- 
     -- Calculate the base matrix (the non-identity part) of the generator
     -- and parity check matrices for a hamming code. This matrix corresponds
     -- with a binary representation of every position of a data bit as rows.
     -- Each row can have an extra parity bit on the right side to correspond 
     -- with the total parity of the row (excluding the parity bit itself)
     --
     -- the size of the returned matrix is m x n where 
     -- m is the number of data bits in the hamming code and
     -- n is the number of parity bits in the code (including the extra parity
     -- bit for extended hamming codes).
     --
     -- @asserts error: if parity bits < 2
     -- @param p: integer: the number of parity bits in the code (excluding
     -- the extra parity bit for extended hamming codes) 
     -- @param e: boolean: whether to use an extra parity bit
     -- @returns matrix: the base matrix
     function base_matrix(p: integer; e: boolean) return matrix is 
          variable d: integer    := calc_data_bits(p);
          variable pos: intvec_t(d - 1 downto 0) := calc_nonpower(p);

          variable v: unsigned(p - 1 downto 0);
          variable m: matrix(d - 1 downto 0, p - 1 downto 0);
     begin 
          -- set all positions of the databits as a row to the matrix 
          for i in m'range(1) loop
               v := to_unsigned(pos(i), p);
               for j in m'range(2) loop 
                    m(i, j) := v(j);
               end loop;
          end loop;
          
          -- if extended hamming code, add a parity bit to each row (inverted)
          if e then
               return m * (identity(p) & ones(p)) + (zeros(d, p) & ones(d));
          else 
               return m;
          end if;
     end function base_matrix;
     
     -- base_matrix
     -- 
     -- Calculate the base matrix (the non-identity part) of the generator
     -- and parity check matrices for a hamming code. This matrix corresponds
     -- with a binary representation of every position of a data bit as rows.
     -- Each row can have an extra parity bit on the right side to correspond 
     -- with the total parity of the row (excluding the parity bit itself)
     --
     -- the size of the returned matrix is m x n where 
     -- m is the number of data bits in the hamming code and
     -- n is the number of parity bits in the code (including the extra parity
     -- bit for extended hamming codes).
     --
     -- @asserts error: if parity bits < 2
     -- @param hamming: hamming_t the hamming code for which to calculate 
     -- the base matrix 
     -- @returns matrix: the base matrix
     function base_matrix(hamming: hamming_t) return matrix is 
     begin 
          return base_matrix(hamming.parity_bits, hamming.extended);
     end function base_matrix;

     -- generator_matrix
     -- 
     -- Calculate the generator matrix for a hamming code
     --
     -- the size of the returned matrix is m x n where 
     -- m is the number of data bits in the hamming code and
     -- n is the number of total bits in the code (including the extra parity
     -- bit for extended hamming codes).
     --
     -- @asserts error: if parity bits < 2
     -- @param p: integer: the number of parity bits in the hamming code
     -- excluding the extra parity bit for extended hamming codes
     -- @param e: boolean: use extended hamming codes 
     -- @returns matrix: the generator matrix
     function generator_matrix(p: integer; e: boolean) return matrix is
     begin 
          return concat_identity_left(base_matrix(p, e));
     end function generator_matrix;

     -- generator_matrix
     -- 
     -- Calculate the generator matrix for a hamming code
     --
     -- the size of the returned matrix is m x n where 
     -- m is the number of data bits in the hamming code and
     -- n is the number of total bits in the code (including the extra parity
     -- bit for extended hamming codes).
     --
     -- @asserts error: if parity bits < 2
     -- @param hamming: hamming_t the hamming code for which to calculate 
     -- the generator matrix 
     -- @returns matrix: the generator matrix
     function generator_matrix(hamming: hamming_t) return matrix is
     begin 
          return concat_identity_left(base_matrix(hamming));
     end function generator_matrix;

     -- parity_check_matrix
     -- 
     -- Calculate the generator matrix for a hamming code
     --
     -- the size of the returned matrix is m x n where 
     -- m is the number of parity bits in the hamming code and
     -- n is the number of total bits in the code (including the extra parity
     -- bit for extended hamming codes).
     --
     -- @asserts error: if parity bits < 2
     -- @param p: integer: the number of parity bits in the hamming code
     -- excluding the extra parity bit for extended hamming codes
     -- @param e: boolean: use extended hamming codes 
     -- @returns matrix: the parity check matrix
     function parity_check_matrix(p: integer; e: boolean) return matrix is 
     begin 
          return concat_identity_right(transpose(base_matrix(p, e)));
     end function parity_check_matrix;
     
     -- parity_check_matrix
     -- 
     -- Calculate the generator matrix for a hamming code
     --
     -- the size of the returned matrix is m x n where 
     -- m is the number of parity bits in the hamming code and
     -- n is the number of total bits in the code (including the extra parity
     -- bit for extended hamming codes).
     --
     -- @asserts error: if parity bits < 2
     -- @param hamming: hamming_t the hamming code for which to calculate 
     -- the parity check matrix 
     -- @returns matrix: the parity check matrix
     function parity_check_matrix(hamming: hamming_t) return matrix is 
     begin 
          return concat_identity_right(transpose(base_matrix(hamming)));
     end function parity_check_matrix;
     
     -- encode 
     -- 
     -- Encodes a data string into a Hamming code
     -- Returns a vector corresponding to the maximum total bits of
     -- the Hamming code. If the given data vector is shorter than 
     -- the maximum data bits of the code, then 0's will be appended 
     -- at the MSB. If the given data vector is longer than the maximum
     -- data bits of the code, the lower part will be used and a warning
     -- is asserted.
     --
     -- @asserts warning: if the length of the data vector is longer 
     -- than the maximum data bits of the code.
     --
     -- @param gen_matrix: matrix: The generator matrix to be used
     -- @param data: std_logic_vector: The data to be encoded
     -- @returns std_logic_vector: The encoded string
     function encode(gen_matrix: matrix; data: std_logic_vector) return std_logic_vector is 
          variable v_in : vector(gen_matrix'range(1));
     begin 
          if data'length > v_in'length then
               assert false 
                    report "Data vector is too long for this generator matrix, cropping to " 
                         & integer'image(v_in'length)
                         & " bits"
                    severity warning;
               v_in := to_vector(data(v_in'range));
          elsif data'length = v_in'length then 
               v_in := to_vector(data);
          else
               v_in(v_in'range'left - 1 downto data'length) := (others => '0');
               v_in(data'range'left downto 0) := to_vector(data);
          end if;
          return to_logic_vector(v_in * gen_matrix);
     end function encode;

     -- encode 
     -- 
     -- Encodes a data string into a Hamming code
     -- Returns a vector corresponding to the maximum total bits of
     -- the Hamming code. If the given data vector is shorter than 
     -- the maximum data bits of the code, then 0's will be appended 
     -- at the MSB. If the given data vector is longer than the maximum
     -- data bits of the code, the lower part will be used and a warning
     -- is asserted.
     --
     -- @asserts warning: if the length of the data vector is longer 
     -- than the maximum data bits of the code.
     --
     -- @param p: integer: The number of parity bits of the code excluding 
     -- extra parity bits for extended hamming codes
     -- @param e: boolean: Whether to use extended hamming codes
     -- @param data: std_logic_vector: The data to be encoded
     -- @returns std_logic_vector: The encoded string
     function encode(p: integer; e: boolean; data: std_logic_vector) return std_logic_vector is 
     begin 
          return encode(generator_matrix(p, e), data);
     end function encode;

     -- encode 
     -- 
     -- Encodes a data string into a Hamming code
     -- Returns a vector corresponding to the maximum total bits of
     -- the Hamming code, or of length parity bits + data bits if it is 
     -- less than the maximum total bits. If the given data vector is shorter
     -- than the maximum data bits of the code, then 0's will be appended 
     -- at the MSB. If the given data vector is longer than the maximum
     -- data bits of the code, the lower part will be used and a warning
     -- is asserted.
     --
     -- @asserts warning: if the length of the data vector is longer 
     -- than the maximum data bits of the code.
     --
     -- @param hamming: hamming_t: The parameters of the Hamming code
     -- @param data: std_logic_vector: The data to be encoded
     -- @returns std_logic_vector: The encoded string
     function encode(hamming: hamming_t; data: std_logic_vector) return std_logic_vector is 
     begin 
          return encode(generator_matrix(hamming), hamming.data_bits, data);
     end function encode;

     -- encode 
     -- 
     -- Encodes a data string into a Hamming code
     -- Returns a vector corresponding to the maximum total bits of
     -- the Hamming code, or of length parity bits + data bits if it is 
     -- less than the maximum total bits. If the given data vector is shorter
     -- than the maximum data bits of the code, then 0's will be appended 
     -- at the MSB. If the given data vector is longer than the maximum
     -- data bits of the code, the lower part will be used and a warning
     -- is asserted.
     --
     -- @asserts warning: if the length of the data vector is longer 
     -- than the maximum data bits of the code.
     -- @asserts warning: if the number of data bits is longer more than 
     -- the maximum number of data bits
     --
     -- @param gen_matrix: matrix: The generator matrix to be used
     -- @param d: integer: The number of data bits in the return value
     -- @param data: std_logic_vector: The data to be encoded
     -- @returns std_logic_vector: The encoded string
     function encode(gen_matrix: matrix; d: integer; data: std_logic_vector) return std_logic_vector is 
          variable width: integer;
     begin 
          if d > gen_matrix'length(2) then 
               assert false 
                    report "The number of data bits is larger than the maximum allowed."
                    severity warning;
               width := gen_matrix'length(2);
          else 
               width := d;
          end if;
          return encode(gen_matrix, data)(width - 1 downto 0);          
     end function encode;

     -- encode 
     -- 
     -- Encodes a data string into a Hamming code
     -- Returns a vector corresponding to the maximum total bits of
     -- the Hamming code, or of length parity bits + data bits if it is 
     -- less than the maximum total bits. If the given data vector is shorter
     -- than the maximum data bits of the code, then 0's will be appended 
     -- at the MSB. If the given data vector is longer than the maximum
     -- data bits of the code, the lower part will be used and a warning
     -- is asserted.
     --
     -- @asserts warning: if the length of the data vector is longer 
     -- than the maximum data bits of the code.
     -- @asserts warning: if the number of data bits is longer more than 
     -- the maximum number of data bits
     --
     -- @param gen_matrix: matrix: The generator matrix to be used
     -- @param d: integer: The number of data bits in the return value
     -- @param data: std_logic_vector: The data to be encoded
     -- @returns std_logic_vector: The encoded string
     function encode(p: integer; d: integer; e: boolean; data: std_logic_vector) return std_logic_vector is 
     begin 
          return encode(generator_matrix(p, e), d, data);
     end function encode;


end package body;