/*
 * ALU module
 * TODO
 * Documentation, merge other operations
 */

`ifndef ALU_V
`define ALU_V

`include "src/config.vh"

module alu32 #(
	parameter addsuber = 1,
	parameter multiplier = 1
)(
	input clk,
	input rst,
	input clr,
	input en,
	input [`KEY_SIZE-1:0] key_in,
	input [`OPCODE_SIZE-1:0] op,
	input [`OPERAND_SIZE-1:0] inA,
	input [`OPERAND_SIZE-1:0] inB,
	output reg [`KEY_SIZE-1:0] key_out,
	output reg [`OPERAND_SIZE-1:0] out
);


generate
	if (addsuber) begin
		wire addsub_select = (op == `SUB) ? 1'b1 : 1'b0;
		wire [31:0] addsubO;
		SB_MAC16 #(
			.B_SIGNED(1'b0),
			.A_SIGNED(1'b0),
			.MODE_8x8(1'b0),
			.BOTADDSUB_CARRYSELECT(2'b10),
			.BOTADDSUB_UPPERINPUT(1'b1),
			.BOTADDSUB_LOWERINPUT(2'b00),
			.BOTOUTPUT_SELECT(2'b00),
			.TOPADDSUB_CARRYSELECT(2'b10),
			.TOPADDSUB_UPPERINPUT(1'b1),
			.TOPADDSUB_LOWERINPUT(2'b00),
			.TOPOUTPUT_SELECT(2'b00),
			.PIPELINE_16x16_MULT_REG2(1'b0),
			.PIPELINE_16x16_MULT_REG1(1'b0),
			.BOT_8x8_MULT_REG(1'b0),
			.TOP_8x8_MULT_REG(1'b0),
			.D_REG(1'b0),
			.B_REG(1'b0),
			.A_REG(1'b0),
			.C_REG(1'b0)
		) m_addsuber (
			.A(inB[31:16]),
			.B(inB[15:0]),
			.C(inA[31:16]),
			.D(inA[15:0]),
			.CLK(clk),
			.CE(1'b1),
			.IRSTTOP(rst),
			.IRSTBOT(rst),
			.ORSTTOP(rst),
			.ORSTBOT(rst),
			.AHOLD(1'b0),
			.BHOLD(1'b0),
			.CHOLD(1'b0),
			.DHOLD(1'b0),
			.OHOLDTOP(1'b0),
			.OHOLDBOT(1'b0),
			.OLOADTOP(1'b0),
			.OLOADBOT(1'b0),
			.ADDSUBTOP(addsub_select),
			.ADDSUBBOT(addsub_select),
			.CO(),
			.CI(1'b0),
			.O(addsubO)
		);
	end
	if (multiplier) begin
		wire [31:0] inA_abs = inA[31] ? ~inA+1 : inA;
		wire [31:0] inB_abs = inB[31] ? ~inB+1 : inB;
		wire [15:0] mulA = state == 0 ? inA_abs[31:16] :
							state == 1 ? inA_abs[15:0] :
							state == 2 ? inA_abs[31:16] :
							state == 3 ? inA_abs[15:0] :
							16'h0000;
		wire [15:0] mulB = state == 0 ? inB_abs[31:16] :
							state == 1 ? inB_abs[15:0] :
							state == 2 ? inB_abs[15:0] :
							state == 3 ? inB_abs[31:16] :
							16'h0000;
		wire [15:0] mulC = state == 0 ? 16'h0000 :
							state == 1 ? 16'h0000 :
							state == 2 ? buff_mul[31:16] :
							state == 3 ? buff_mul[31:16] :
							16'h0000;
		wire [15:0] mulD = state == 0 ? 16'h0000 :
							state == 1 ? 16'h0000 :
							state == 2 ? buff_mul[15:0] :
							state == 3 ? buff_mul[15:0] :
							16'h0000;
		wire [31:0] mulO;
		SB_MAC16 #(
			.A_SIGNED(1'b0),
			.B_SIGNED(1'b0),
			.MODE_8x8(1'b0),
			.BOTADDSUB_CARRYSELECT(2'b00),
			.BOTADDSUB_UPPERINPUT(1'b1),
			.BOTADDSUB_LOWERINPUT(2'b10),
			.BOTOUTPUT_SELECT(2'b00),
			.TOPADDSUB_CARRYSELECT(2'b10),
			.TOPADDSUB_UPPERINPUT(1'b1),
			.TOPADDSUB_LOWERINPUT(2'b10),
			.TOPOUTPUT_SELECT(2'b00),
			.PIPELINE_16x16_MULT_REG2(1'b0),
			.PIPELINE_16x16_MULT_REG1(1'b0),
			.BOT_8x8_MULT_REG(1'b0),
			.TOP_8x8_MULT_REG(1'b0),
			.D_REG(1'b0),
			.B_REG(1'b0),
			.A_REG(1'b0),
			.C_REG(1'b0)
		) m_mul (
			.A(mulA),
			.B(mulB),
			.C(mulC),
			.D(mulD),
			.CLK(clk),
			.CE(1'b1),
			.IRSTTOP(rst),
			.IRSTBOT(rst),
			.ORSTTOP(rst),
			.ORSTBOT(rst),
			.AHOLD(1'b0),
			.BHOLD(1'b0),
			.CHOLD(1'b0),
			.DHOLD(1'b0),
			.OHOLDTOP(1'b0),
			.OHOLDBOT(1'b0),
			.OLOADTOP(1'b0),
			.OLOADBOT(1'b0),
			.ADDSUBTOP(1'b0),
			.ADDSUBBOT(1'b0),
			.CO(),
			.CI(1'b0),
			.O(mulO)
		);
	end
	if (!addsuber && !multiplier) begin
		initial begin
			$display("alu32: Invalid parameters");
			$display("no operation selected");
			$finish(1);
		end
	end

	reg [1:0] state;
	reg [31:0] buff_mul;
	always @(posedge clk) begin
		if (rst || clr) begin
			out <= 32'h00000000;
			key_out <= 8'h00;
			state <= 2'b00;
			buff_mul <= 32'h00000000;
		end else if (en && key_out != key_in) begin
			if (op == `ADD && addsuber) begin
				out <= addsubO;
				key_out <= key_in;
				state <= 2'b00;
			end else if (op == `SUB && addsuber) begin
				out <= addsubO;
				key_out <= key_in;
				state <= 2'b00;
			end else if (op == `MUL && multiplier) begin
				state <= state + 1;
				if (state == 0) begin
					out <= 32'hxxxxxxxx;
					key_out <= 8'h00;
					buff_mul[31:16] <= mulO[15:0];
				end else if (state == 1) begin
					out <= 32'hxxxxxxxx;
					key_out <= 8'h00;
					buff_mul[15:0] <= mulO[31:16];
				end else if (state == 2) begin
					out <= 32'hxxxxxxxx;
					key_out <= 8'h00;
					buff_mul <= mulO;
				end else begin
					out <= inA[31] ^ inB[31] ? ~mulO+1 : mulO;
					key_out <= key_in;
				end
			end else begin
				out <= 32'h00000000;
				key_out <= key_in;
			end
		end else begin
			out <= out;
			key_out <= key_out;
		end
	end
	
endgenerate

endmodule

`endif
