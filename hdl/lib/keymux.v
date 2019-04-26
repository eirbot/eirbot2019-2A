/*
 * Keyed multiplexer for alu32 module
 * TODO
 * Documentation
 */

`ifndef KEYMUX_V
`define KEYMUX_V

`include "src/config.vh"

module keymux #(
	parameter ninputs = 1,
)(
	input clk,
	input rst,
	input [8*ninputs-1:0] op_i,
	input [8*ninputs-1:0] key_i,
	input [32*ninputs-1:0] A_i,
	input [32*ninputs-1:0] B_i,
	input [7:0] keyback_i,
	output reg [7:0] op_o,
	output reg [7:0] key_o,
	output reg [31:0] A_o,
	output reg [31:0] B_o
);

reg [8*ninputs-1:0] key_buff;

generate
	if (ninputs) begin
		integer i;
		always @(posedge clk) begin
			if (rst) begin
				key_buff <= {ninputs{8'h00}};
			end else begin
				for (i = 0; i < ninputs; i++) begin
					if ((key_i[8*(i+1)-1:8*i] != key_buff[8*(i+1)-1:8*i])
							&& keyback_i == key_o) begin
						op_o <= op_i[8*(i+1)-1:8*i];
						key_o <= key_i[8*(i+1)-1:8*i];
						A_o <= A_i[32*(i+1)-1:32*i];
						B_o <= B_i[32*(i+1)-1:32*i];
						key_buff[8*(i+1)-1:8*i] <= key_i[8*(i+1)-1:8*i];
					end
				end
			end
		end
	end else begin
		initial begin
			$display("keymux: ninputs set to 0");
			$display("instantiate this module with ninputs > 0");
			$finish(1);
		end
	end
endgenerate

endmodule

`endif
