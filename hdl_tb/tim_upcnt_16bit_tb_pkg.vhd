library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

package tim_upcnt_16bit_tb_pkg is

  constant c_system_clock_in_hz             : natural := 100_000_000;
  constant c_clk_period                     : time := 1 sec / c_system_clock_in_hz;

  constant separator : string := "-------------------------------------------------------------------";

  procedure walk (
    signal   clk   : in std_logic;
    constant steps : natural := 1
  );

end package tim_upcnt_16bit_tb_pkg;

package body tim_upcnt_16bit_tb_pkg is

  procedure walk (
    signal   clk   : in std_logic;
    constant steps : natural := 1
    ) is
  begin
    if steps /= 0 then
      for step in 0 to steps - 1 loop
        wait until rising_edge(clk);
      end loop;
    end if;
  end procedure;

end package body tim_upcnt_16bit_tb_pkg;