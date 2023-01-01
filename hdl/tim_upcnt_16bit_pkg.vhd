library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Evaluate if package is even needed...

package tim_upcnt_16bit_pkg is

  type t_tim_upcnt_16bit_conf is record
    number_of_digits                : natural;
    digit_change_interval_bit_size  : natural;
    digit_change_interval           : natural;
  end record;
  
  function generics_verification(
    tim_upcnt_16bit_conf : t_tim_upcnt_16bit_conf
  ) return boolean;

end package tim_upcnt_16bit_pkg;

package body tim_upcnt_16bit_pkg is

  function generics_verification(
    tim_upcnt_16bit_conf : t_tim_upcnt_16bit_conf
  ) return boolean is
  begin
    -- assert (tim_upcnt_16bit_conf.number_of_digits > 0)
    --   report "tim_upcnt_16bit_conf.number_of_digits must be greater than 0!"
    --   severity failure;
  end function;

end package body tim_upcnt_16bit_pkg;