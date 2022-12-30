# tim_upcnt_16bit_lib
A basic 16-bit timer, heavily inspired by timers available in STM32 microcontrollers.  
Consists of a 16-bit auto-reload counter driven by a programmable prescaler.  
Can be used as generic timer for time base generation, can be chained with anoter instance to provide longer time periods.  

## Module's main features
* 16-bit auto-reload upcounter.
* 16-bit programmable prescaler used to divide the counter clock frequency by any fraction between 0x0001 and 0xFFFF.
* Both configuration values can be updated on-the-fly and take into effect after the next timer overflow event.
* Written in VHDL, project organized and verified with VUnit.
```
TIM_EN
  ---------------+
                 |
CLK_INT    +-----v-----+
  ---------> Control   |
           +-----+-----+
                 |CLK_PSC
                 |
           +-----v-----+             +-------------+       TIM_UP
TIM_PSC    | PSC       | CLK_CNT     |             +------------>
  ---------> prescaler +------------->             |
           +-----------+             |   CNT       |       TIM_OV
                                     |   counter   +------------>
TIM_ARR    +--------------------+    |             |
 ---------->Auto-reload register+---->             |       TIM_CNT
           +--------------------+    |             +------------>
                                     +-------------+
```

## Module's functional description

### Time-base unit
The main block is a 16-bit upcounter with its related auto-reload register. The counter clock can be divided with a prescaler. Te auto-reload register and the prescaler register can be written even when the counter is running.  
The time-base unit includes:
* Counter register value (TIM_CNT)
* Prescale register (TIM_PSC)
* Auto-reload register (TIM_ARR)
The counter is clocked by the prescaler output (CLK_CNT), which is enabled only when the counter is enabled (TIM_EN asserted).

**Prescaler description**  
The prescaler can divide the counter clock frequency by any factor between 0x0001 and 0xFFFF. It is based on a 16-bit counter controlled through a 16-bit register (set by the TIM_PSC). It can be changed on the fly as the TIM_PSC signal is buffered. The new prescaler ratio is taken into account at the next update event.

### Counting mode
The counter counts from 0x0000 to auto-reload value, then restarts from 0x0000 and generates a counter overflow signal (TIM_OV). Each time counter is incremented a counter up signal is generated (TIM_UP). Those signals are available for one cycle of CLK_INT. In addition, current counter value is passed outside via TIM_CNT vector.  
When an counter overflow event occurs, all registers are updated:
* The buffer of the prescaler value is reloaded with the new prescaler value (TIM_PSC).
* The auto-reload register is updated wiht the new preload value (TIM_ARR).

### Clock source
The counter clock is provided by the intenal clock (CLK_INT) source.  
As soon as the TIM_EN signal is asserted, the prescaler is clocked by the CLK_INT.

## Project requirements for simulation
* Modelsim simulator installed
* Modelsim.ini file visible in the PATH
* Modelsim win32acoem folder added to the PATH
* VUnit installed
* Python 3.* installed (for VUnit)
* OPTIONAL: GHDL
