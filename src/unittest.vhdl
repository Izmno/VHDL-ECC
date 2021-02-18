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
-- File Name:       unittest.vhdl
-- File Type:       VHDL Package
--
-- Create Date:     14 feb 2021
-- Design Name:     unittest
-- Module Name:     unittest
-- Project Name:    ECC
-- Target Devices: 
-- Tool Versions:   ghdl 0.37
-- Description: 
--   Package provides functionality to simplify unittests VHDL packages, 
--   specifically for functions of these packages.
-- 
-- Dependencies:
--   - (ieee.std_logic_1164) 
--   - (ieee.numeric_std)
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

library std;
use std.textio.all;


---------------------------------
-- UNITTEST                    --
---------------------------------
package unittest is
    -----------------------------
    -- TYPE DEFINITIONS        --
    -----------------------------
    
    -- Base type for a single test
    type test_t is record 
        name: line;
        description: line;
        expected: line;
        result: line;
        passed: boolean;
    end record test_t;

    -- Access type for a single test
    type test_ptr_t is access test_t;

    -- Base type for an array of tests 
    type testarray_t is array (integer range <>) of test_t;

    -- Access type for a list of tests
    type testlist_t is access testarray_t;

    -- Base type for a testrun
    type testrun_t is record
        name: line;
        description: line;
        tests: testlist_t;
        
        num_tests: integer;
        num_passed: integer;
        num_failed: integer;
    end record testrun_t;

    -- Access type for a testrun
    type testrun_ptr_t is access testrun_t;

    -----------------------------
    -- FUNCTION PROTOTYPES     --
    -----------------------------
    -- Description in body     --
    -----------------------------
    function create_run(name: string) return testrun_t;
    function create_run(name: string; description: string) return testrun_t;
    function create_test(name: string) return test_t;
    function create_test(name: string; description: string) return test_t;
    function create_test(name: string; description: string; expected: string; result: string) return test_t;
    function create_test(name: string; description: string; expected: string; result: string; passed: boolean) return test_t;

    -----------------------------
    -- UTILITY PROTOTYPES      --
    -----------------------------
    -- Description in body     --
    -----------------------------
    function to_string(v: std_logic_vector) return string;
    function to_character(l: std_logic) return character;

    -----------------------------
    -- PROCEDURE PROTOTYPES    --
    -----------------------------
    -- Description in body     --
    -----------------------------
    procedure add_test(list: inout testlist_t; test: inout test_t);
    procedure add_test(run: inout testrun_t; test: inout test_t);
    procedure remove_test(list: inout testlist_t; index: in integer); 
    procedure remove_test(run: inout testrun_t; index: in integer);

    procedure report_test(test: inout test_t; testnumber: in integer);
    procedure report_test(run: inout testrun_t);
    procedure report_test(run: inout testrun_t; testnumber: in integer);

    procedure report_all_tests(run: inout testrun_t);

    procedure report_run_header(run: inout testrun_t);
    procedure report_run(run: inout testrun_t);

    procedure start_test(run: inout testrun_t; name: in string; description: in string; expected: in string; result: in string);
    procedure finish_test(run: inout testrun_t; passed: in boolean);

    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in integer; result: in integer);
    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in real; result: in real);
    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in boolean; result: in boolean);
    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in std_logic; result: in std_logic);
    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in std_logic_vector; result: in std_logic_vector);

    
end package unittest;

---------------------------------
-- UNITTEST BODY               --
---------------------------------
package body unittest is
    -----------------------------
    -- FUNCTION BODIES         --
    -----------------------------
    function create_run(name: string) return testrun_t is
        variable run: testrun_t;
        variable lname: line;
        variable ldescription: line;
    begin 
        write(lname, name);
        run := (
            name => lname,
            description => ldescription,
            tests => null,
            num_tests => 0,
            num_passed => 0,
            num_failed => 0
        );
        return run;
    end function create_run;

    function create_run(name: string; description: string) return testrun_t is
        variable run: testrun_t;
        variable lname: line;
        variable ldescription: line;
    begin 
        write(lname, name);
        write(ldescription, description);
        run := (
            name => lname,
            description => ldescription,
            tests => null,
            num_tests => 0,
            num_passed => 0,
            num_failed => 0
        );
        return run;
    end function create_run;


    function create_test(name: string) return test_t is 
        variable lname: line;
        variable ldescription: line;
        variable lexpected: line;
        variable lresult: line;
        variable test: test_t;
    begin 
        write(lname, name);
        test := (
            name => lname,
            description => ldescription,
            expected => lexpected,
            result => lresult,
            passed => false
        );
        return test;
    end function create_test;

    function create_test(name: string; description: string) return test_t is 
        variable lname: line;
        variable ldescription: line;
        variable lexpected: line;
        variable lresult: line;
        variable test: test_t;
    begin 
        write(lname, name);
        write(ldescription, description);
        test := (
            name => lname,
            description => ldescription,
            expected => lexpected,
            result => lresult,
            passed => false
        );
        return test;
    end function create_test;

    function create_test(name: string; description: string; expected: string; result: string) return test_t is 
        variable lname: line;
        variable ldescription: line;
        variable lexpected: line;
        variable lresult: line;
        variable test: test_t;
    begin 
        write(lname, name);
        write(ldescription, description);
        write(lexpected, expected);
        write(lresult, result);
        test := (
            name => lname,
            description => ldescription,
            expected => lexpected,
            result => lresult,
            passed => false
        );
        return test;
    end function create_test;

    function create_test(name: string; description: string; expected: string; result: string; passed: boolean) return test_t is 
        variable lname: line;
        variable ldescription: line;
        variable lexpected: line;
        variable lresult: line;
        variable test: test_t;
    begin 
        write(lname, name);
        write(ldescription, description);
        write(lexpected, expected);
        write(lresult, result);
        test := (
            name => lname,
            description => ldescription,
            expected => lexpected,
            result => lresult,
            passed => passed
        );
        return test;
    end function create_test;

    -----------------------------
    -- UTILITY BODIES          --
    -----------------------------
    function to_string(v: std_logic_vector) return string is 
        variable bfr: line;
        variable c: character;
    begin 
        write(bfr, string'("b'"));
        for i in v'range loop
            c := to_character(v(i));
            write(bfr, c);
        end loop;
        return bfr.all;
    end function to_string;

    function to_character(l: std_logic) return character is 
        variable c: character;
    begin 
        case l is
            when '0' => c := '0';
            when '1' => c := '1';
            when 'H' => c := 'H';
            when 'L' => c := 'L';
            when 'Z' => c := 'Z';
            when 'W' => c := 'W';
            when 'X' => c := 'X';
            when 'U' => c := 'U';
            when '-' => c := '-';
            when others => c := '?';
        end case;
        return c;
    end function to_character;
            
    -----------------------------
    -- PROCEDURE BODIES        --
    -----------------------------
    procedure add_test(list: inout testlist_t; test: inout test_t) is
        variable newlist: testlist_t;
        variable length: integer;
    begin 
        newlist := new testarray_t(1 to list'length + 1);
        newlist(list'range) := list(list'range);
        newlist(newlist'length) := test;
        deallocate(list);
        list := newlist;
    end procedure add_test;

    procedure add_test(run: inout testrun_t; test: inout test_t) is
    begin 
        if run.tests = null then
            run.tests := new testarray_t(1 to 1);
            run.tests(1) := test;
        else
            add_test(run.tests, test);
        end if;
    end procedure add_test;

    -- TO BE IMPLEMENTED
    procedure remove_test(list: inout testlist_t; index: in integer) is
    begin 
        assert false 
            report "Procedure remove_test is not yet implemented"
            severity warning;
    end procedure remove_test;

    -- TO BE IMPLEMENTED
    procedure remove_test(run: inout testrun_t; index: in integer) is
    begin 
        assert false 
            report "Procedure remove_test is not yet implemented"
            severity warning;
    end procedure remove_test;

    procedure report_test(test: inout test_t; testnumber: in integer) is
        variable result: string(1 to 4);
        variable bfr: line;
    begin
        -- process result line
        if test.passed then
            result := "PASS";
        else 
            result := "FAIL";
        end if;
        -- HEADER
        write(bfr, string'("## TEST "));
        write(bfr, integer'image(testnumber));
        write(bfr, string'(": '"));
        write(bfr, test.name.all);
        write(bfr, string'("' (" & result & ")") & LF);
        write(output, bfr.all);
        bfr := null;
        if test.description /= null then
            if test.description.all'length > 0 then
                write(bfr, string'("## "));
                write(bfr, test.description.all & LF);
                write(output, bfr.all);
            end if;
        end if;
        -- EXPECTED AND RESULT
        bfr := null;
        if test.expected /= null then
            if test.expected.all'length > 0 then
                write(bfr, string'("## Expected return value:") & LF);
                write(bfr, test.expected.all & LF);
                write(output, bfr.all);
            end if;
        end if;
        bfr := null;
        if test.result /= null then
            if test.result.all'length > 0 then
                write(bfr, string'("## Return value:") & LF);
                write(bfr, test.result.all & LF);
                write(output, bfr.all);
            end if;
        end if;
        -- PASS OR FAIL
        write(output, string'("## Result: " & result & LF));
    end procedure report_test;

    procedure report_test(run: inout testrun_t) is
        variable number: integer;
        variable test: test_t;
    begin 
        if run.tests /= null then
            number := run.tests'length;
            test := run.tests(number);
            report_test(test, number);
        else
            assert false 
                report "No tests to report in run"
                severity note;
        end if;
    end procedure report_test;

    procedure report_test(run: inout testrun_t; testnumber: in integer) is
        variable length: integer;
        variable test: test_t;
    begin 
        
        if run.tests /= null then
            length := run.tests'length;
        else
            length := 0;
        end if;

        if testnumber < 1 or testnumber > length then
            assert false 
                report "No test with testnumber " & integer'image(testnumber) & " in this testrun"
                severity note;
        else 
            test := run.tests(testnumber);
            report_test(test, testnumber);
        end if;
    end procedure report_test;

    -- TO BE IMPLEMENTED
    procedure report_all_tests(run: inout testrun_t) is
    begin 
        assert false 
            report "Procedure report_all_tests is not yet implemented"
            severity warning;
    end procedure report_all_tests;

    -- TO BE IMPLEMENTED
    -- 
    -- print a header for the testrun
    procedure report_run_header(run: inout testrun_t) is
    begin 
        assert false 
            report "Procedure report_run_header is not yet implemented"
            severity warning;
    end procedure report_run_header;

    -- TO BE IMPLEMENTED
    --
    -- print an overview of the entire run
    procedure report_run(run: inout testrun_t) is 
    begin 
        assert false 
            report "Procedure report_run is not yet implemeneted"
            severity warning;
    end procedure report_run;

    -- Add a new test to the testrun with name, description, expected and result
    procedure start_test(run: inout testrun_t; name: in string; description: in string; expected: in string; result: in string) is
        variable test: test_t;
    begin 
        test := create_test(name, description, expected, result);
        add_test(run, test);
    end procedure;


    -- Set the passed flag in the last test of the testrun
    -- Print a report of the test
    -- Assert a warning if the test failed
    -- Assert an error if there is no last test
    procedure finish_test(run: inout testrun_t; passed: in boolean) is
        variable number: integer;
    begin 
        if run.tests /= null then
            number := run.tests'length;
        else 
            number := 0;
            assert false 
                report "There are no tests in this testrun to finish"
                severity error;
        end if;

        if number /= 0 then
            run.tests(number).passed := passed;
            report_test(run);
            assert passed
                report "Test " & run.tests(number).name.all & " failed."
                severity warning;
            assert not passed
                report "Test " & run.tests(number).name.all & " passed."
                severity note;
            write(output, string'("") & LF);
        end if;
    end procedure finish_test;

    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in integer; result: in integer) is
    begin 
        start_test(run, name, description, integer'image(expected), integer'image(result));
        finish_test(run, expected = result);
    end procedure run_test;

    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in real; result: in real) is
    begin 
        start_test(run, name, description, real'image(expected), real'image(result));
        finish_test(run, expected = result);
    end procedure run_test;

    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in boolean; result: in boolean) is
    begin 
        start_test(run, name, description, boolean'image(expected), boolean'image(result));
        finish_test(run, expected = result);
    end procedure run_test;
    
    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in std_logic; result: in std_logic) is
    begin 
        start_test(run, name, description, std_logic'image(expected), std_logic'image(result));
        finish_test(run, expected = result);
    end procedure run_test;   

    procedure run_test(run: inout testrun_t; name: in string; description: in string; expected: in std_logic_vector; result: in std_logic_vector) is
    begin 
        start_test(run, name, description, to_string(expected), to_string(result));
        finish_test(run, expected = result);
    end procedure run_test;

end package body unittest;

     