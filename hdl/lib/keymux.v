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
	input [ninputs*`OPCODE_SIZE-1:0] op_i,
	input [ninputs*`KEY_SIZE-1:0] key_i,
	input [ninputs*`OPERAND_SIZE-1:0] A_i,
	input [ninputs*`OPERAND_SIZE-1:0] B_i,
	input [`KEY_SIZE-1:0] keyback_i,
	output reg [`OPCODE_SIZE-1:0] op_o,
	output reg [`KEY_SIZE-1:0] key_o,
	output reg [`OPERAND_SIZE-1:0] A_o,
	output reg [`OPERAND_SIZE-1:0] B_o
);

reg [ninputs*`KEY_SIZE-1:0] key_buff;

generate
	if (ninputs) begin
		integer i;
		always @(posedge clk) begin
			if (rst) begin
				key_buff <= {ninputs{8'h00}};
			end else begin
				for (i = 0; i < ninputs; i++) begin
					if ((key_i[`KEY_SIZE*(i+1)-1:`KEY_SIZE*i]
							!= key_buff[`KEY_SIZE*(i+1)-1:`KEY_SIZE*i])
							&& keyback_i == key_o) begin
						op_o <= op_i[`OPCODE_SIZE*(i+1)-1:`OPCODE_SIZE*i];
						key_o <= key_i[`KEY_SIZE*(i+1)-1:`KEY_SIZE*i];
						A_o <= A_i[32*(i+1)-1:32*i];
						B_o <= B_i[32*(i+1)-1:32*i];
						key_buff[`KEY_SIZE*(i+1)-1:`KEY_SIZE*i] <= key_i[`KEY_SIZE*(i+1)-1:`KEY_SIZE*i];
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
