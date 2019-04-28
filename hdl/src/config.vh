`ifndef _CONFIG_VH_
`define _CONFIG_VH_

// General parameters
`define CLK_FREQ 48000000

// LED parameters
`define LED_NBPC 8

// PID parameters
`define PID_RES 32
`define PID_SPEED_FREQ 333
`define PID_POS_FREQ 333

// PWM parameters
`define PWM_FREQ (`CLK_FREQ/2**11)
`define PWM_RES 10

// QEI parameters
`define QEI_RES 16

`endif
