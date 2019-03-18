/*
 * Top module
 */

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
wire [23:0] demo_rgb;

// Internal oscillator to genereate clock
SB_HFOSC inthosc (
	.CLKHFPU(1'b1),
	.CLKHFEN(1'b1),
	.CLKHF(clk)
);

// RGB LED

rgb #(
	.nbpc(8)
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
	.nbits(16)
) pwm (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(2**15),
	.out(pwm_o)
);

endmodule
