`timescale 1ns / 1ps
module genric_fixed_arbiter_tb();
   parameter N = 32;
   parameter clk_period = 10;
   reg  [N-1:0] req_i;
   wire [N-1:0] grant_o ;
    
  /*--------------------------------------------------------------------------------------*/
  genric_fixed_arbiter #(
    .N(N)
    )
    dut_genric_fixed_arbiter(
    .req_i(req_i),
    .grant_o(grant_o)
  );
  
  /*----------------------------------------------------------------------------------------------*/
  reg clk = 0;
  always #(clk_period/2) clk = ~clk;
  
  // testcases
  
  initial begin

        // Initialize inputs
        req_i = 32'd0;
        #10;
        @(posedge clk);
        req_i = 32'd0;
        @(posedge clk);
        req_i = 32'd1;
        @(posedge clk);
        req_i = 32'd3; 
        @(posedge clk);
        req_i = 32'd0;
        @(posedge clk);
        req_i = 32'd3;
        @(posedge clk);
        req_i = 32'd0; 
      
             // Finish simulation
        @(posedge clk);
        $finish;
  end
endmodule
