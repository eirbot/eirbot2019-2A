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
`define PIDL_BASE_KEY 4'h02
`define PIDR_BASE_KEY 4'h05

// Motors parameters
`define PWM_FREQ (`CLK_FREQ/2**11)
`define PWM_RES 10
`define DIR_MOTOR_L 1'b0
`define DIR_MOTOR_R 1'b1

// QEI parameters
`define QEI_RES 16

// ALU parameters
`define KEY_SIZE 4
`define OPCODE_SIZE 4
`define OPERAND_SIZE 32
`define NULLOP `OPCODE_SIZE'h0
`define ADD `OPCODE_SIZE'h1
`define SUB `OPCODE_SIZE'h2
`define MUL `OPCODE_SIZE'h3

`endif
