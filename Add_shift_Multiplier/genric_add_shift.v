/*
  Module Name : genric_add_shift
  Description : This  multiplier module that is genric is implemented to multiply two input.
                It follow the process of shift and add based upon the bit position of b.
*/
//-------------------------------------------------------------------------------------------
`timescale 1ns / 1ps
module genric_add_shift#(
parameter input_a_bit = 4,
parameter input_b_bit = 4,
parameter output_result_bit = input_a_bit + input_b_bit
)
(
  input [input_a_bit-1 :0] a,
  input [input_b_bit-1 :0] b,
  output [ output_result_bit-1 :0] result
);

reg [output_result_bit-1 :0] a_extended_shift_reg ;
reg [ output_result_bit-1 :0] result_reg ;
////--------------------------------------------------------------------------------------------
/*
  Here the Logic is written via combitorial loop as there is no clock signal required
  for the Mathmatical operation. After this if you want to control the logic via the 
  control or clocked based signal then you can create an FSM via gnerate if construct
  to control the output by taking output into intermediate register.
*/
//-----------------------------------------------------------------------------------------------
integer i  ;
always @ (*) begin
     result_reg  = 0;
     a_extended_shift_reg = {4'h0,a};
     for ( i = 0 ; i < input_a_bit; i = i+1)
     begin
         if (b[i]==1 )
         begin
           result_reg = result_reg + (a_extended_shift_reg<<i);
         end
     end
end
assign result =  result_reg;
endmodule
