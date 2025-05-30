`timescale 1ns / 1ps

module hamming_code_decoder_rx_tb();
  parameter K       = 8 ;//Information bit vector size
  parameter LATENCY = 0 ; //0: no latency (combinatorial design)
                         //1: registered outputs
                         //2: registered inputs+outputs
  parameter P0_LSB  = 1 ; //0: p0 is located at MSB
                         //1: p0 is located at LSB

  //These should be localparams
  parameter m = calculate_m(K);
  parameter n = m + K;
  /*--------------------------------------------------------------------------------------------------------------------------------*/
    //clock/reset ports (if LATENCY > 0)
  reg              rst_ni;    //asynchronous reset
  reg              clk_i;     //clock input
  reg              clkena_i;  //clock enable input

  //data ports
  reg             [n  :0] d_i;       //encoded code word input
  wire            [K-1:0] q_o;       //information bit vector output
  wire            [m  :0] syndrome_o; //syndrome vector output

  //flags
  wire            sb_err_o;   //single bit error detected
  wire            db_err_o;   //double bit error detected
  wire            sb_fix_o ;   //repaired error in the information bits
 /*--------------------------------------------------------------------------------------------------------------------------------*/
  function integer calculate_m(input integer k);
  integer m;
begin
  m=1;
  while (2**m < m+k+1) m++;

  calculate_m = m;
end
endfunction //calculate_m
/*--------------------------------------------------------------------------------------------------------------------------------*/
/* instantiating the module*/
hamming_code_decoder_rx #(
.K(K),
.LATENCY(LATENCY),
.P0_LSB(P0_LSB),
.m(m),
.n(n)

)
dut_hamming_code_decoder_ports(
.rst_ni(rst_ni),
.clk_i(clk_i),
.clkena_i(clkena_i),
.d_i(d_i),
.q_o(q_o),
.syndrome_o(syndrome_o),
.sb_err_o(sb_err_o),
.db_err_o(db_err_o),
.sb_fix_o(sb_fix_o)
);
/*--------------------------------------------------------------------------------------------------------------------------------*/
/*---------clk_generation logic---------------------*/
initial begin;
clk_i  = 0;
forever #5 clk_i = ~clk_i;
end

/*-------------------------test stimuli-------------------------*/

initial begin
d_i = 13'b0000010011001;
#10;
d_i = 13'b0000110011001; // p8 flip
#10;
d_i = 13'b0000111011001; //  here d7 flip then getting correct data w.r.t q_0 (0d) .Hence showing error db_error_O in simulation.
#10;

#100;
$finish;
end

initial begin
$monitor ("the parity decoder Out : time = %dns |d_i = %b |q_o = %b | syndrome_o = %b|",$time ,d_i,q_o,syndrome_o);
end
endmodule
