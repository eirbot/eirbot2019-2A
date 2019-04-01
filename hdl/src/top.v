/*
 * Top module
 * TODO
 * Documentation
 */

`include "config.vh"

module top(
	// Global inputs
	input rst,
	// QEI inputs
	input qeiL_A,
	input qeiL_B,
	// LED outputs
	output ledR,
	output ledG,
	output ledB,
	// Motor outputs
	output pwm_o,
);

// Global signals
wire clk;

//assign led_o = leds;
wire [15:0] qei_val;

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

// PWM
pwm #(
	.freq(`PWM_FREQ),
	.nbits(`PWM_RES)
) pwm (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(10'd2**9),
	.out(pwm_o)
);

// QEI
qei #(
	.nbits(16)
) qei (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.in_A(qeiL_A),
	.in_B(qeiL_B),
	.val(qei_val)
);

endmodule
