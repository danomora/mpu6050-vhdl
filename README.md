# MPU6050 VHDL

System Interface :
----------------

| Pins   | Io | Notes |
| -------- | ---- | --------------------- |
| clk_50 | clock | Master clock (50 MHz) |
| reset_n | input | Asynchronious reset active low | 
| en | input | enable |
| i2c_sdat | input | input data bus i2c |
| i2c_sclk | input | output clk i2c bus |
| gx[15:0] | output | gyro x  16-bit 2’s complement value. |
| gy[15:0] | output | gyro y 16-bit 2’s complement value.  |
| gz[15:0] | output | gyro z 16-bit 2’s complement value.  | 
| ax[15:0] | output | acc x 16-bit 2’s complement value.  |
| ay[15:0] | output | acc y 16-bit 2’s complement value.  |
| az[15:0] | output | acc z 16-bit 2’s complement value.  |

Contains:
1. mpu_rg.vhd   ---- Vhdl for reading raw values
2. mpu_rg_avalon.vhd ---- Memory mapped interface (Avalon tm) for mpu_rg

3. sensor.c ---- Complementary filter for nios ii using mpu_rg_avalon, (need floating point).

How to use:
1. en=1
2. It will give you raw acc and gyro values.

How to obtain pitch and roll values:
Using a processor like NIOS II and using C code incluided.

Test project made in Quartus 18.1:
https://1drv.ms/u/s!Asbr1H_ypU3ziYonkMjt88yz0R79Xg?e=U66aPa

Questions:
dmorang@hotmail.com

https://www.linkedin.com/in/danmorang/

Daniel Moran.
