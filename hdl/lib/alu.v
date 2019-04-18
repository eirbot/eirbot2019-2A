/*
 * ALU module
 * TODO
 * Pretty much everything
 */

`ifndef ALU_V
`define ALU_V

`include "src/config.vh"
`include "counter.v"

module alu #(
)(
	input clk,
	input rst,
	input clr,
	input en,
	input [31:0] inA,
	input [31:0] inB,
	input [31:0] inC,
	input [31:0] inD,
	input [8:0] key_in,
	output reg [23:0] out,
	output reg [8:0] key_out
);

localparam idle = 8'h00;
localparam busy1 = 8'h00;
localparam busy2 = 8'h00;
localparam busy3 = 8'h00;

wire [31:0] mulout;
wire [31:0] muladdout;

reg [15:0] A, B, C, D;
reg state = 0;

SB_MAC16 #(
	.B_SIGNED(1'b0),
	.A_SIGNED(1'b0),
	.MODE_8x8(1'b0),
	.BOTADDSUB_CARRYSELECT(2'b00),
	.BOTADDSUB_UPPERINPUT(1'b0),
	.BOTADDSUB_LOWERINPUT(2'b00),
	.BOTOUTPUT_SELECT(2'b11),
	.TOPADDSUB_CARRYSELECT(2'b00),
	.TOPADDSUB_UPPERINPUT(1'b0),
	.TOPADDSUB_LOWERINPUT(2'b00),
	.TOPOUTPUT_SELECT(2'b11),
	.PIPELINE_16x16_MULT_REG2(1'b0),
	.PIPELINE_16x16_MULT_REG1(1'b0),
	.BOT_8x8_MULT_REG(1'b1),
	.TOP_8x8_MULT_REG(1'b1),
	.D_REG(1'b0),
	.B_REG(1'b1),
	.A_REG(1'b1),
	.C_REG(1'b0)
) m_mul (
	.A(inA[15:0]),
	.B(inB[15:0]),
	.C(16'b0),
	.D(16'b0),
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
	.O(mulout)
);

// A*B+{CD}
SB_MAC16 #(
	.B_SIGNED(1'b0),
	.A_SIGNED(1'b0),
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
) m_muladd (
	.A(A),
	.B(B),
	.C(C),
	.D(D),
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
	.O(muladdout)
);

always @(posedge clk)
begin
	/*
	if (mulout == 32'h000006E4 && muladdout == 32'h00000054) begin
		out <= 24'h000f00;
	end else if (muladdout == 32'h00000054) begin
		out <= 24'h00000f;
	end else if (mulout == 32'h000006E4) begin
		out <= 24'h000f0f;
	end else begin
		out <= 24'h0f0000;
	end
	if (muladdout == 32'h0001005D) begin
		out <= 24'h000f00;
	end else begin
		out <= 24'h0f0000;
	end
	*/
	state <= state + 1;
	if (state == 1'd0) begin
		A <= 16'd0;
		B <= 16'd0;
		C <= 16'd0;
		D <= 16'd0;
		out <= (muladdout == 32'd65629) ? 24'h000f00 : 24'hff0000;
	end else begin
		A <= 16'd16;
		B <= 16'd5;
		C <= 16'd1;
		D <= 16'd13;
		out <= (muladdout == 32'd0) ? 24'h00000f : 24'hff0000;
	end
			
end

endmodule

`endif
