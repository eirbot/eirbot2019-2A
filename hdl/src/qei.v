/*
 * Qei module
 * TODO
 * Documentation
 */

`include "config.vh"

module qei #(
	parameter nbits = 16
)(
	input clk,
	input rst,
	input clr,
	input en,
	input in_A,
	input in_B,
	output reg [nbits-1:0] val
);

reg prev_A;
reg prev_B;

always @(posedge clk)
begin
	if (rst || clr)
	begin
		val <= 0;
	end
	else if (en)
	begin
		val <= (in_A != prev_A) && in_A && (in_B == prev_B) && !in_B ? val+1 :
				(in_A == prev_A) && in_A && (in_B != prev_B) && in_B ? val+1 :
				(in_A != prev_A) && !in_A && (in_B == prev_B) && in_B ? val+1 :
				(in_A == prev_A) && !in_A && (in_B != prev_B) && !in_B ? val+1 :


				(in_A != prev_A) && in_A && (in_B == prev_B) && in_B ? val-1 :
				(in_A == prev_A) && in_A && (in_B != prev_B) && !in_B ? val-1 :
				(in_A != prev_A) && !in_A && (in_B == prev_B) && !in_B ? val-1 :
				(in_A == prev_A) && !in_A && (in_B != prev_B) && in_B ? val-1 :

				val;
	end
	prev_A <= in_A;
	prev_B <= in_B;
end

endmodule
