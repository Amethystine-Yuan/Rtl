
module DEFF(input wire clk,
            input wire D,
            input wire rst_n,
            output wire Q);
  reg p, n;
  always@(posedge clk or negedge rst_n) begin
      if (!rst_n) p <= 1'b0;
      else p <= D ^ n;
  end
  always@(negedge clk or negedge rst_n) begin
      if (!rst_n) n <= 1'b0;
      else n <= D ^ p;
  end
  assign Q = p ^ n;
endmodule

// module DEFFE(input wire clk,
//             input wire EN,
//             input wire D,
//             input wire rst_n,
//             output wire Q);
//   reg p, n;
//   always@(posedge clk or negedge rst_n) begin
//       if (!rst_n) p <= 1'b0;
//       else if(EN) p <= D ^ n;
//       else p <= p;
//   end
//   always@(negedge clk or negedge rst_n) begin
//       if (!rst_n) n <= 1'b0;
//       else if(EN) n <= D ^ p;
//       else n <= n;
//   end
//   assign Q = p ^ n;
// endmodule