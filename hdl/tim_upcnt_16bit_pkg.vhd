library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Evaluate if package is even needed...

package tim_upcnt_16bit_pkg is

  type t_tim_upcnt_16bit_reg is record
    psc : std_logic_vector(15 downto 0);
    arr : std_logic_vector(15 downto 0);
  end record;

end package tim_upcnt_16bit_pkg;

package body tim_upcnt_16bit_pkg is

end package body tim_upcnt_16bit_pkg;