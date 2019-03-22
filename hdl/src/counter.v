`timescale 1ns/1ps

module counter #(
	parameter nbits = 8,
	parameter min = 0,
	parameter max = 2**nbits-1,
	parameter signed step = 1
)(
	input clk,
	input rst,
	input clr,
	input en,
	output reg [nbits-1:0] count,
	output reg overflow
);

generate
	if (step > 0)
	begin
		always @(posedge clk)
		begin
			if (rst || clr)
			begin
				count <= 0;
			end
			else if (en)
			begin
				if (count + step > max)
				begin
					count <= min;
					overflow <= 1;
				end
				else
				begin
					count <= count + step;
					overflow <= 0;
				end
			end
			else
			begin
				count <= count;
				overflow <= overflow;
			end
		end
	end
	else if (step < 0)
	begin
		always @(posedge clk)
		begin
			if (rst || clr)
			begin
				count <= 0;
			end
			else if (en)
			begin
				if (count + step < min)
				begin
					count <= max;
					overflow <= 1;
				end
				else
				begin
					count <= count + step;
					overflow <= 0;
				end
			end
			else
			begin
				count <= count;
				overflow <= overflow;
			end
		end
	end
	else
	begin
		initial
		begin
			$display("counter: invalid parameters");
			$display("Null step");
			$finish(1);
		end
	end
endgenerate

endmodule
