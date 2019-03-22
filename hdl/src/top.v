/*
 * Top module
 * TODO
 * Documentation
 */

`include "config.vh"

module top(
	// LED outputs
	output ledR,
	output ledG,
	output ledB,
	output pwm_o,
	output clk_o
);

// Global signals
wire clk;
reg rst = 1'b0;
assign clk_o = clk;
// RGB signals
wire [3*`LED_NBPC-1:0] demo_rgb;

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
	.in(demo_rgb),
	.ledR(ledR),
	.ledG(ledG),
	.ledB(ledB)
);

rgb_demo #(
) rgb_demo (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.out(demo_rgb)
);

// PWM
pwm #(
	.freq(`PWM_FREQ),
	.nbits(`PWM_RES)
) pwm (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(10'd2**14),
	.out(pwm_o)
);

endmodule
