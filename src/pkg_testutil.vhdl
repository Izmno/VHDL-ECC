library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library std;
use std.textio.all;

package pkg_testutil is

    type lines_t is array(integer range <>) of line;

    type testutil_reporter_t is record
        num_tests:  integer;
        num_passed: integer;
        test_name: line;
        -- name of the function currently being tested
        curr_func: line;
        curr_expectation: line;
        curr_output: line;
        curr_expectation_desc: line;
    end record testutil_reporter_t;
    
    procedure overwrite(buf: inout line; s: in string);
    procedure writeln(buf: inout text; s: in string);
    procedure writeln(buf: inout text; l: inout line);
    procedure writeln(buf: inout line; s: in string);
    procedure writeln(buf: inout line; l: inout line);

    procedure testutil_init_reporter(test_name: in string; reporter: out testutil_reporter_t);

    procedure testutil_func_start(reporter: inout testutil_reporter_t; name: in string);
    procedure testutil_func_result(reporter: inout testutil_reporter_t; description: in string; expectation: in string; result: in string);
    procedure testutil_func_report(reporter: inout testutil_reporter_t; test: in boolean);
end package pkg_testutil;

package body pkg_testutil is 


    procedure overwrite(buf: inout line; s: in string) is 
    begin 
        if buf /= null then 
            if buf.all'length > 0 then
                buf := null;
            end if;
        end if;
        write(buf, s);
    end procedure overwrite;


    procedure writeln(buf: inout text; s: in string) is 
    begin 
        write(buf, s & LF);
    end procedure writeln;

    procedure writeln(buf: inout text; l: inout line) is 
    begin 
        write(buf, l.all & LF);
        l := null;
    end procedure writeln;
    
    procedure writeln(buf: inout line; s: in string) is 
    begin 
        write(buf, s & LF);
    end procedure writeln; 


    procedure writeln(buf: inout line; l: inout line) is 
    begin 
        write(buf, l.all & LF);
        l := null;
    end procedure writeln;




    procedure testutil_init_reporter(test_name: in string; reporter: out testutil_reporter_t) is 
        variable r : testutil_reporter_t := (
            num_tests => 0,
            num_passed => 0,
            test_name => null,
            curr_func => null,
            curr_expectation => null,
            curr_output => null,
            curr_expectation_desc => null
        );
    begin 
        writeln(output, "Initializing test " & test_name);
        writeln(output, "");
        writeln(output, "");
        write(r.test_name, test_name);
        reporter := r;
    end procedure testutil_init_reporter;

    procedure testutil_func_start(reporter: inout testutil_reporter_t; name: in string) is 
    begin

        reporter.num_tests := reporter.num_tests + 1;
        overwrite(reporter.curr_func, name);

        writeln(output, "##");
        writeln(output, "## TEST " & integer'image(reporter.num_tests) & ": '" & reporter.curr_func.all & "'");

    end procedure testutil_func_start;


    procedure testutil_func_result(reporter: inout testutil_reporter_t; description: in string; expectation: in string; result: in string) is
    begin 
        overwrite(reporter.curr_expectation, expectation);
        overwrite(reporter.curr_output, result);
        overwrite(reporter.curr_expectation_desc, description);
    end procedure testutil_func_result;


    procedure testutil_func_report(reporter: inout testutil_reporter_t; test: in boolean) is 
    begin 

        if reporter.curr_expectation_desc /= null then 
            if reporter.curr_expectation_desc.all'length > 0 then
                write(output, "## ");
                writeln(output, reporter.curr_expectation_desc);
            end if;
        end if;

        writeln(output, "##");

        if reporter.curr_expectation /= null then
            writeln(output, "Expected output:");
            writeln(output, reporter.curr_expectation.all);
        end if;

        if reporter.curr_output /= null then 
            writeln(output, "Actual output:");
            writeln(output, reporter.curr_output.all);
        end if;

        if test then 
            reporter.num_passed := reporter.num_passed + 1;
            writeln(output, "## TEST " & integer'image(reporter.num_tests) & " PASSED");
            report "function '" & reporter.curr_func.all & "' passed";
        else 
            writeln(output, "## TEST " & integer'image(reporter.num_tests) & " FAILED");
            assert test
                report "function '" & reporter.curr_func.all & "' failed" 
                severity error;
        end if;
        writeln(output, "");
        writeln(output, "");
    end procedure testutil_func_report;

    end package body pkg_testutil;