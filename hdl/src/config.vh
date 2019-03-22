`ifndef _CONFIG_VH_
`define _CONFIG_VH_

// General parameters
`define CLK_FREQ 48000000

// LED parameters
`define LED_NBPC 8

// PWM parameters
`define PWM_FREQ `CLK_FREQ/2**11
`define PWM_RES 10

`endif
