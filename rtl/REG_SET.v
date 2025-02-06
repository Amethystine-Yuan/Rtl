module REG_SET (
input clk,
input rst_n,
input D,
output Q
);
reg REG;
always@(posedge clk or negedge rst_n)
	if (!rst_n)
		REG <= 1'b1;
	else REG <= D;
assign Q=REG;
endmodule
