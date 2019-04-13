/*
 * RGB led module
 * TODO
 * Documentation
 */

`ifndef RGB_V
`define RGB_V

`include "src/config.vh"
`include "counter.v"

module rgb #(
	parameter nbpc = `LED_NBPC,
	parameter max = 2**nbpc-1
)(
	input clk,
	input rst,
	input en,
	input [3*nbpc-1:0] in,
	output ledR,
	output ledG,
	output ledB
);

reg ledR_pwm;
reg ledG_pwm;
reg ledB_pwm;
wire [nbpc-1:0] count;

always @(posedge clk)
begin
	if (rst || !en)
	begin
		ledR_pwm <= 1'b0;
		ledG_pwm <= 1'b0;
		ledB_pwm <= 1'b0;
	end
	else
	begin
		ledR_pwm <= count<in[3*nbpc-1:2*nbpc] ? 1'b1 : 1'b0;
		ledG_pwm <= count<in[2*nbpc-1:1*nbpc] ? 1'b1 : 1'b0;
		ledB_pwm <= count<in[1*nbpc-1:0*nbpc] ? 1'b1 : 1'b0;
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
SB_RGBA_DRV RGBA_DRIVER (
	.CURREN(1'b1),
	.RGBLEDEN(1'b1),
	.RGB0PWM(ledG_pwm),
	.RGB1PWM(ledB_pwm),
	.RGB2PWM(ledR_pwm),
	.RGB0(ledG),
	.RGB1(ledB),
	.RGB2(ledR)
);
defparam RGBA_DRIVER.CURRENT_MODE = "0b1";
defparam RGBA_DRIVER.RGB0_CURRENT = "0b000111";
defparam RGBA_DRIVER.RGB1_CURRENT = "0b000111";
defparam RGBA_DRIVER.RGB2_CURRENT = "0b000111";

endmodule

`endif
