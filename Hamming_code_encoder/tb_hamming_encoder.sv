`timescale 1ns / 1ps

module tb_hamming_encoder();
  parameter K       = 8; //Information bit vector size
  parameter P0_LSB  = 1; //0: p0 is located at MSB
                         //1: p0 is located at LSB

  //these should be localparams
  parameter m = calculate_m(K);
  parameter n = m + K;
  reg  [K-1:0] d_i;      //information bit vector input
  wire [n  :0] q_o;     //encoded data word output

  wire [m  :1] p_o;     //parity vector output
  wire         p0_o ;     //extended parity bit
  
  function integer calculate_m;
  input integer k;

  integer m;
begin
  m=1;
  while (2**m < m+k+1) m++;

  calculate_m = m;
end
endfunction //calculate_m
 /*
    instantiation of module
    
 */
 ecc_enc #(
 .K(K),
 .P0_LSB(P0_LSB),
 .m(m),
 .n(n)
 )
 dut_hamming_encoder(
 .d_i(d_i),
 .q_o(q_o),
 .p_o(p_o),
 .p0_o(p0_o)
 );
 
 
initial begin
d_i= 8'b1001;
#10;
d_i = 8'b0001;
#10;

#100;
$finish;

end


initial begin
$monitor ("The encoded_output : time = %dns |data_in = %b | q_o = %b ",$time,d_i, {q_o[0], q_o[1], q_o[2], q_o[3], q_o[4], q_o[5], q_o[6], q_o[7], q_o[8], q_o[9], q_o[10], q_o[11], q_o[12]});

end
endmodule
