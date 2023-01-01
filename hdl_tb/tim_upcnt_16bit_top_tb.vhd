library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

library tim_upcnt_16bit_lib;
use tim_upcnt_16bit_lib.tim_upcnt_16bit_pkg.all;


entity tim_upcnt_16bit_top_tb is
  generic (runner_cfg : string := runner_cfg_default);
end entity;

architecture tb of tim_upcnt_16bit_top_tb is

  signal dut_clk                  : std_logic := '0';
  signal dut_rst_n                : std_logic := '0';
  signal dut_tim_en               : std_logic := '0';
  signal dut_tim_psc              : std_logic_vector(15 downto 0) := (others => '0');
  signal dut_tim_arr              : std_logic_vector(15 downto 0) := (others => '0');
  signal dut_tim_up               : std_logic;
  signal dut_tim_ov               : std_logic;
  signal dut_tim_cnt              : std_logic_vector(15 downto 0);

begin

  -- dut_clk <= not dut_clk after (c_clk_period/2);

  uut : entity tim_upcnt_16bit_lib.tim_upcnt_16bit_top(rtl)
    port map (
      i_clk     => dut_clk,
      i_rst_n   => dut_rst_n,
      i_tim_en  => dut_tim_en,
      i_tim_psc => dut_tim_psc,
      i_tim_arr => dut_tim_arr,
      o_tim_up  => dut_tim_up,
      o_tim_ov  => dut_tim_ov,
      o_tim_cnt => dut_tim_cnt
    );

  main : process
    variable v_time_start : time;
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_0001_output_ports_in_reset") then
        -- info(separator);
        info("===== TEST CASE STARTED =====");
        info("TEST CASE: test_0001_output_ports_in_reset");
        -- info(separator);
        info("===== TEST CASE FINISHED =====");
      end if;
    end loop;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;

end architecture;
