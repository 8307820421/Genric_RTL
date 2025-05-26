
/*
   Module 
*/
`timescale 1ns / 1ps
module hamming_code_encoder#(
parameter data_byte  = 1,         // input bit vector width
parameter k          = 8, /*data_byte*8,*/
parameter P0_LSB     = 1,
parameter m          = calculate_m(k), // parity width
parameter encoded_data_bits = (m+k)  // output  width 
)(
   input  [k-1:0] data_in,
   output [encoded_data_bits :0] encoded_out,
   output [m:1] parity_o,
   output       extended_parity_o
 );
 
 /*--------------------------------------------------------------------------------------*/
 /*
   step1) Via the hamming code formulae develop the function to calcuate the parity width
 */
 /*--------------------------------------------------------------------------------------*/
 function integer calculate_m;
 input integer k;
 
 integer m;
 
 begin
     m = 1;  // Missing initialization!
     while (2**m < m+k+1)
      m = m+1;
      calculate_m = m;
  end
 endfunction 
 
  /*--------------------------------------------------------------------------------------*/
 /*
   step2) function to calculate the data_in position which are not power of two 
   and placed at the return type arguments of function.
   --> The index starts n:1.
   --> we need to store the dbit index at ecodeded_out index . Hence loop goes to 
       to <= encoded_data_bits.
 */
 /*--------------------------------------------------------------------------------------*/
 
 function [encoded_data_bits :1] store_dbits_encoded_out;
 input [k-1 :0] data_in;
 integer dbit_idx,encode_idx; // Here dbit and encode idx required as dbit logic
 begin
    store_dbits_encoded_out = 0; // intitially all bit position is 0.
    dbit_idx = 0;
    for (encode_idx = 1; encode_idx <= encoded_data_bits ; encode_idx = encode_idx+1) begin
         if (2**$clog2(encode_idx)!= encode_idx) begin
               store_dbits_encoded_out[encode_idx] = data_in[dbit_idx];
               dbit_idx  = dbit_idx+1;   
        end
    end
 end
 endfunction
 
  /*--------------------------------------------------------------------------------------*/
 /*
   step3)function to calculate the parity bits position values with the help of encoded bitss
         and parity idx.
     ---> Using reduction OR operator with bitwise & operator of parity_idx and encoded_out_idx.
         
 */
 /*--------------------------------------------------------------------------------------*/
  function [m:1] calculate_parity_p;
  input [encoded_data_bits :1] encoded_code_out;
  integer p_idx, encode_idx;   // here parity bit and encode idx as parity bit logic
  begin
      calculate_parity_p = 0;
     for (p_idx = 1; p_idx <=m ; p_idx = p_idx+1)begin
       for (encode_idx = 1 ; encode_idx <= encoded_data_bits ; encode_idx = encode_idx+1)begin
            if (|(2**(p_idx-1)&encode_idx)) begin// parallel  
               calculate_parity_p[p_idx] = calculate_parity_p[p_idx]^encoded_code_out[encode_idx];
            end
       end
    end
  end       
  endfunction
  
 /*--------------------------------------------------------------------------------------*/
 /*
   step4) function to place the parity bit posotion at specific index of ecoded_out_index
          which are power of two.
 */
 
 /*--------------------------------------------------------------------------------------*/
 function [encoded_data_bits : 1] store_p_in_encoded_out;
  input [encoded_data_bits :1] encoded_code_word;
 input [m:1] Parity;
 integer i;
 begin
  store_p_in_encoded_out = encoded_code_word; // follow continous (both dbits +parity)
      for ( i = 1; i <=m ; i = i+1)begin
          store_p_in_encoded_out[2**(i-1)] = Parity[i];
      end
  end
 endfunction
  
 /*--------------------------------------------------------------------------------------*/
 /*
   step5) Continuous assignment to encoded_code_word, as well as Parity_o, extended_parity_o
          encoded_o.
 */
 
 /*--------------------------------------------------------------------------------------*/
 wire [encoded_data_bits :1] cw_dbits; // for dbits;
 wire [encoded_data_bits :1] code_p_w; // for parity_o and cw_dbits;
 
 assign cw_dbits          = store_dbits_encoded_out(data_in); // dbits function 
 assign parity_o          = calculate_parity_p(cw_dbits);  // parity bit function
 assign code_p_w          =  store_p_in_encoded_out(cw_dbits,parity_o); // final cw dbits and parity
 
 assign extended_parity_o = ^code_p_w;
 
 /*---------------------FINAL OUT-----------------------------------------------------------------*/
 assign encoded_out = P0_LSB ? { code_p_w, extended_parity_o}:{extended_parity_o, code_p_w};
endmodule
