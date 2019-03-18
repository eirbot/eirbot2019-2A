`timescale 1ns/1ps

module pwm #(
	parameter nbits = 8,
	parameter max = 2^nbits-1
)(
	input clk,
	input rst,
	input en,
	input [nbits-1:0] in,
	output reg out
);

wire [nbits-1:0] val;

counter #(
	.nbits(nbits),
	.min(0),
	.max(max),
	.step(1)
) counter (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(en),
	.count(val),
	.overflow()
);

always @(posedge clk)
begin
	if (rst)
	begin
		out = 0;
	end
	else
	begin
		out <= en && val<in ? 1'b1 : 1'b0;
	end
end

endmodule
