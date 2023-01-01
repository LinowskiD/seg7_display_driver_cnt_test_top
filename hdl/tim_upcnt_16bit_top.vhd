library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library tim_upcnt_16bit_lib;
use tim_upcnt_16bit_lib.tim_upcnt_16bit_pkg.all;

entity tim_upcnt_16bit_top is
  port (
    i_clk     : in  std_logic;
    i_rst_n   : in  std_logic;
    i_tim_en  : in  std_logic;
    i_tim_psc : in  std_logic_vector(15 downto 0);
    i_tim_arr : in  std_logic_vector(15 downto 0);
    o_tim_up  : out std_logic;
    o_tim_ov  : out std_logic;
    o_tim_cnt : out std_logic_vector(15 downto 0)
  );
end entity tim_upcnt_16bit_top;

architecture rtl of tim_upcnt_16bit_top is

  signal ctrl_en : std_logic;
  signal ctrl_en_r : std_logic;
  signal ctrl_en_re : std_logic;
  signal psc_cnt : unsigned(15 downto 0);
  signal psc_reg : std_logic_vector(15 downto 0);
  signal psc_clk_en : std_logic;

begin

  -- Combinational
  ctrl_en_re <= ctrl_en and (not ctrl_en_r); -- i_tim_en rising edge, update event

  -- Processes
  p_control : process(i_rst_n, i_clk)
  begin
    if (i_rst_n = '0') then
      ctrl_en <= '0';
      ctrl_en_r <= '0';
    elsif rising_edge(i_clk) then
      ctrl_en <= i_tim_en;
      ctrl_en_r <= ctrl_en;
    end if;
  end process;

  p_prescaler : process(i_rst_n, i_clk)
  begin
    if (i_rst_n = '0') then
      psc_cnt <= (others => '0');
      psc_reg <= (others => '0');
      psc_clk_en <= '0';
    elsif rising_edge(i_clk) then
      psc_clk_en <= '0';
      if (ctrl_en = '0') then
        psc_cnt <= (others => '0');
        psc_reg <= (others => '0');
      else
        if (ctrl_en_re = '1') then
          psc_reg <= i_tim_psc;
        else
          if (psc_cnt < unsigned(psc_reg)) then
            psc_cnt <= psc_cnt + 1;
          else
            psc_cnt <= (others => '0');
            psc_clk_en <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

end architecture rtl;