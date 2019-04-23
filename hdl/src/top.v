/*
 * Top module
 * TODO
 * Documentation
 */

`include "src/config.vh"
`include "lib/counter.v"
`include "lib/pid.v"
`include "lib/pwm.v"
`include "lib/qei.v"
`include "lib/rgb.v"
`include "lib/alu32.v"

module top(
	// Global inputs
	input rst,
	// QEI inputs
	input qeiL_A,
	input qeiL_B,
	input qeiR_A,
	input qeiR_B,
	// LED outputs
	output ledR,
	output ledG,
	output ledB,
	// Motor outputs
	output pwmL,
	output pwmR
);

// Global signals
wire clk;

//assign led_o = leds;
wire [`QEI_RES-1:0] qeiL;
wire [`QEI_RES-1:0] qeiR;

// Tests
wire [31:0] aluO;
reg [23:0] Irgb;

// Internal oscillator to generate clock
SB_HFOSC inthosc (
	.CLKHFPU(1'b1),
	.CLKHFEN(1'b1),
	.CLKHF(clk)
);

// RGB LED
rgb #(
	.nbpc(`LED_NBPC)
) rgb (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(Irgb),
	.ledR(ledR),
	.ledG(ledG),
	.ledB(ledB)
);

pwm #(
	.freq(`PWM_FREQ),
	.nbits(`PWM_RES)
) m_pwmL (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(10'd2**9),
	.out(pwmL)
);

// PWM
pwm #(
	.freq(`PWM_FREQ),
	.nbits(`PWM_RES)
) m_pwmR (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(10'd2**9),
	.out(pwmR)
);

// QEI
qei #(
	.nbits(`QEI_RES)
) m_qeiL (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.in_A(qeiL_A),
	.in_B(qeiL_B),
	.val(qeiL)
);

qei #(
	.nbits(`QEI_RES)
) m_qeiR (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.in_A(qeiR_A),
	.in_B(qeiR_B),
	.val(qeiR)
);

`define INA 32'h23456789
`define INB 32'h01fedcba
//`define INA 32'hffff0000
//`define INB 32'h0000f000
wire [7:0] keyO;

alu32 #(
	.addsuber(1'b1),
	.multiplier(1'b1)
) m_alu32 (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.op(`SUB),
	.key_in(8'h05),
	.inA(`INA),
	.inB(`INB),
	.out(aluO),
	.key_out(keyO)
);

always @(posedge clk) begin
	if (rst) begin
		Irgb <= 24'h000000;
	end else if (keyO == 8'h05) begin
		if (aluO == `INA + `INB) begin
			Irgb <= 24'h000800;
		end else if (aluO == `INA - `INB) begin
			Irgb <= 24'h000008;
		end else if (aluO == 32'h62ad8854) begin
			Irgb <= 24'h00f0f0;
		end else begin
			Irgb <= 24'hff0000;
		end
	end else begin
		Irgb <= 24'h000000;
	end
end

endmodule
