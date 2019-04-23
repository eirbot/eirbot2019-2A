`ifndef RGBDEMO_V
`define RGBDEMO_V

module rgb_demo(
	input clk,
	input rst,
	input en,
	output reg [23:0] out
);

reg [1:0] phase;
wire phase_next;

counter #(
	.nbits(26),
	.max(48000000)
) counter (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(en),
	.count(),
	.overflow(phase_next)
);

always @(posedge clk) begin
	if (phase == 1) begin
		out <= 24'hff0000;
	end else if (phase == 2) begin
		out <= 24'h00ff00;
	end else if (phase == 3) begin
		out <= 24'h0000ff;
	end else begin
		out <= 24'hffffff;
	end
end

always @(posedge clk) begin
	if (phase_next) begin
		phase = phase + 1;
	end
end

endmodule

`endif
