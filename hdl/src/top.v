/*
 * Top module
 * TODO
 * Documentation
 */

`include "config.vh"
`include "lib/counter.v"
`include "lib/pid.v"
`include "lib/pwm.v"
`include "lib/qei.v"
`include "lib/rgb.v"

module top(
	// Global inputs
	input rst,
	// QEI inputs
	input qeiL_A,
	input qeiL_B,
	input qeiR_A,
	input qeiR_B,
	// LED outputs
	output ledR,
	output ledG,
	output ledB,
	// Motor outputs
	output pwmL,
	output pwmR
);

// Global signals
wire clk;

//assign led_o = leds;
wire [`QEI_RES-1:0] qeiL;
wire [`QEI_RES-1:0] qeiR;

// Internal oscillator to generate clock
SB_HFOSC inthosc (
	.CLKHFPU(1'b1),
	.CLKHFEN(1'b1),
	.CLKHF(clk)
);

// RGB LED
rgb #(
	.nbpc(`LED_NBPC)
) rgb (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(24'h0f0f0f),
	.ledR(ledR),
	.ledG(ledG),
	.ledB(ledB)
);

pwm #(
	.freq(`PWM_FREQ),
	.nbits(`PWM_RES)
) m_pwmL (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(10'd2**9),
	.out(pwmL)
);

// PWM
pwm #(
	.freq(`PWM_FREQ),
	.nbits(`PWM_RES)
) m_pwmR (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(10'd2**9),
	.out(pwmR)
);

// QEI
qei #(
	.nbits(`QEI_RES)
) m_qeiL (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.in_A(qeiL_A),
	.in_B(qeiL_B),
	.val(qeiL)
);

qei #(
	.nbits(`QEI_RES)
) m_qeiR (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.in_A(qeiR_A),
	.in_B(qeiR_B),
	.val(qeiR)
);

endmodule
