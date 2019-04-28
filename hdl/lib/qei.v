/*
 * Qei module
 * TODO
 * Documentation
 */

`ifndef QEI_V
`define QEI_V

`include "src/config.vh"

module qei #(
	parameter nbits = `QEI_RES
)(
	input clk,
	input rst,
	input clr,
	input en,
	input A_i,
	input B_i,
	output reg [nbits-1:0] qei_o
);

reg A_buff;
reg B_buff;

always @(posedge clk) begin
	if (rst || clr) begin
		qei_o <= 0;
	end else if (en) begin
		qei_o <= (A_i != A_buff) &&  A_i && (B_i == B_buff) && !B_i ? qei_o+1 :
				(A_i == A_buff) &&  A_i && (B_i != B_buff) &&  B_i ? qei_o+1 :
				(A_i != A_buff) && !A_i && (B_i == B_buff) &&  B_i ? qei_o+1 :
				(A_i == A_buff) && !A_i && (B_i != B_buff) && !B_i ? qei_o+1 :

				(A_i != A_buff) &&  A_i && (B_i == B_buff) &&  B_i ? qei_o-1 :
				(A_i == A_buff) &&  A_i && (B_i != B_buff) && !B_i ? qei_o-1 :
				(A_i != A_buff) && !A_i && (B_i == B_buff) && !B_i ? qei_o-1 :
				(A_i == A_buff) && !A_i && (B_i != B_buff) &&  B_i ? qei_o-1 :

				qei_o;
	end
	A_buff <= A_i;
	B_buff <= B_i;
end

endmodule

`endif
