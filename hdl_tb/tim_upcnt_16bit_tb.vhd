library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

library tim_upcnt_16bit_lib;
use tim_upcnt_16bit_lib.tim_upcnt_16bit_pkg.all;

library tim_upcnt_16bit_tb_lib;
use tim_upcnt_16bit_tb_lib.tim_upcnt_16bit_tb_pkg.all;

entity tim_upcnt_16bit_tb is
  generic (runner_cfg : string := runner_cfg_default);
end entity;

architecture tb of tim_upcnt_16bit_tb is

  signal dut_clk                  : std_logic := '0';
  signal dut_rst_n                : std_logic := '0';
  signal dut_tim_en               : std_logic := '0';
  signal dut_tim_psc              : std_logic_vector(15 downto 0) := (others => '0');
  signal dut_tim_arr              : std_logic_vector(15 downto 0) := (others => '0');
  signal dut_tim_up_evt           : std_logic;
  signal dut_tim_ov_evt           : std_logic;
  signal dut_tim_cnt              : std_logic_vector(15 downto 0);

begin

  dut_clk <= not dut_clk after (c_clk_period/2);

  uut : entity tim_upcnt_16bit_lib.tim_upcnt_16bit_top(rtl)
    port map (
      i_clk         => dut_clk,
      i_rst_n       => dut_rst_n,
      i_tim_en      => dut_tim_en,
      i_tim_psc     => dut_tim_psc,
      i_tim_arr     => dut_tim_arr,
      o_tim_up_evt  => dut_tim_up_evt,
      o_tim_ov_evt  => dut_tim_ov_evt,
      o_tim_cnt     => dut_tim_cnt
    );

  main : process
    -- variable v_time_start : time;
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_0001_output_ports_in_reset") then
        info(separator);
        info("===== TEST CASE STARTED =====");
        info("TEST CASE: test_0001_output_ports_in_reset");
        info(separator);
        info("Wait for additional delta cycle");
        wait for 0 ns; -- for delta cycle
        info("Reset shall be enabled");
        check_equal(dut_rst_n, '0', "for reset to be enabled");
        info("tim_up_evt shall be 0b0");
        check_equal(dut_tim_up_evt, '0', result("for o_tim_up_evt when in reset"));
        info("tim_ov_evt shall be 0b0");
        check_equal(dut_tim_ov_evt, '0', result("for o_tim_ov_evt when in reset"));
        info("tim_cnt shall be 0x0000");
        check_equal(dut_tim_cnt, std_logic_vector(to_unsigned(0, dut_tim_cnt'length)), result("for o_tim_cnt when in reset"));
        info("===== TEST CASE FINISHED =====");
      elsif run("test_0002_psc_0x0000_arr_0xFFFF") then
        info(separator);
        info("===== TEST CASE STARTED =====");
        info("TEST CASE: test_0002_psc_0x0000_arr_0xFFFF");
        info(separator);
        info("Wait for additional delta cycle");
        wait for 0 ns; -- for delta cycle
        info("Reset shall be enabled");
        check_equal(dut_rst_n, '0', "for reset to be enabled");
        info("Disable reset");
        dut_rst_n <= '1';
        info("PSC set to 0x0000");
        dut_tim_psc <= X"0000";
        info("ARR set to 0xFFFF");
        dut_tim_arr <= X"FFFF";
        info("Enable timer");
        walk(dut_clk, 1);
        dut_tim_en <= '1';
        info("Wait for clock cycle and additional delta cycle");
        walk(dut_clk, 1);
        wait for 0 ns; -- for delta cycle
        info("Events shall be cleared");
        check_equal(dut_tim_up_evt, '0', result("for o_tim_up_evt when just enabled"));
        check_equal(dut_tim_ov_evt, '0', result("for o_tim_ov_evt when just enabled"));
        info("Counter shall be cleared");
        check_equal(dut_tim_cnt, std_logic_vector(to_unsigned(0, dut_tim_cnt'length)), result("for o_tim_cnt when in reset"));
        info("Wait for tim_up_evt to occur");
        -- one for tim_en to be registered
        -- then second one for psc_clk_en
        -- then third one for the first actual timer update
        wait until rising_edge(dut_clk);
        wait until (dut_tim_up_evt'event and dut_tim_up_evt = '1') for 3*c_clk_period;
        -- wait for 0 ns; -- for delta cycle
        check_equal(dut_tim_up_evt, '1', result("for o_tim_up_evt when first update happens"));
        check_equal(dut_tim_cnt, std_logic_vector(to_unsigned(1, dut_tim_cnt'length)), result("for o_tim_cnt when first update happens"));
        info("In this case o_tim_up_evt shall be stable but o_tim_cnt shall increment each clock cycle");
        -- wait for 10*c_clk_period;
        walk(dut_clk, 1);
        for inc_nmb in 2 to 11 loop
          wait for c_clk_period;
          -- wait for 0 ns; -- for delta cycle
          check_equal(dut_tim_cnt, std_logic_vector(to_unsigned(inc_nmb, dut_tim_cnt'length)), result("for o_tim_cnt when first update happens"));
        end loop;
        check_equal(dut_tim_up_evt'stable(10*c_clk_period), true, result("for o_tim_up_evt with no actual prescaler"));
        
        -- wait for 10 us;
      end if;
    end loop;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;

end architecture;
