//custom_counter module

module custom_counter
(
	input clk,
	input reset_n,
	//input write,
	//input read,
	//input [63:0] data_in,
	output [31:0] data_out
);

	reg [31:0] counter;

	always @ (posedge clk or negedge reset_n)
	begin
		if (reset_n == 0)
		begin
			counter <= 'b1;
		end
			
		else
		begin
			counter <= counter + 1'b1;
		end
	end
		
	assign data_out = counter;

endmodule 