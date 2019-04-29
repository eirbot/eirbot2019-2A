/*
 * RGB led module
 * TODO
 * Documentation
 */

`ifndef RGB_V
`define RGB_V

`include "src/config.vh"
`include "lib/counter.v"

module rgb #(
	parameter nbpc = `LED_NBPC,
	parameter max = 2**nbpc-1
)(
	input clk,
	input rst,
	input en,
	input [3*nbpc-1:0] rgb_i,
	output R_o,
	output G_o,
	output B_o
);

reg R_pwm;
reg G_pwm;
reg B_pwm;
wire [nbpc-1:0] count;

always @(posedge clk) begin
	if (rst || !en) begin
		R_pwm <= 1'b0;
		G_pwm <= 1'b0;
		B_pwm <= 1'b0;
	end else begin
		R_pwm <= count < rgb_i[3*nbpc-1:2*nbpc];
		G_pwm <= count < rgb_i[2*nbpc-1:1*nbpc];
		B_pwm <= count < rgb_i[1*nbpc-1:0*nbpc];
	end
end

counter #(
	.nbits(nbpc),
	.min(0),
	.max(max),
	.step(1)
) counter (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(en),
	.count(count),
	.overflow()
);

// LED Driver
SB_RGBA_DRV #(
	.CURRENT_MODE("0b1"),
	.RGB0_CURRENT("0b000111"),
	.RGB1_CURRENT("0b000111"),
	.RGB2_CURRENT("0b000111")
) RGBA_DRIVER (
	.CURREN(1'b1),
	.RGBLEDEN(en),
	.RGB0PWM(G_pwm),
	.RGB1PWM(B_pwm),
	.RGB2PWM(R_pwm),
	.RGB0(G_o),
	.RGB1(B_o),
	.RGB2(R_o)
);

endmodule

`endif
