/*
 * LMD18200 control module
 * TODO
 * Documentation
 */

`ifndef LMD18200_V
`define LMD18200_V

`include "src/config.vh"
`include "lib/pwm.v"

module LMD18200 #(
	parameter freq = `PWM_FREQ,
	parameter nbits = `PWM_RES+1,
	parameter dir_motor = 1'b0
)(
	input clk,
	input rst,
	input en,
	input [nbits-1:0] pwm_i,
	output pwm_o,
	output reg dir_o,
	output reg br_o
);

wire pwm_unsigned = pwm_i[nbits-1] ? (~pwm_i[nbits-2:0]+1) : pwm_i[nbits-2:0];

pwm #(
    .freq(freq),
    .nbits(nbits-1)
) m_pwm (
    .clk(clk),
    .rst(rst),
    .en(en),
    .pwm_i(pwm_unsigned),
    .pwm_o(pwm_o)
);

always @(posedge clk) begin
	if (rst) begin
		br_o <= 1'b0;
		dir_o <=  1'b0;
	end else if (en) begin
		br_o <= 1'b0;
		dir_o <= pwm_i[nbits-1] ^ dir_motor;
	end
end

endmodule
