/*
Module Name : Add Shit Multiplier 
Description : This module is used to first shift the first input (a)  based upon the bit position of b indexing.
              The a is shifting based upon the bit index of b but where the bit position of b is 1'b1; Otherwise 
              keep the value same.
             And then add them each resultant output to get the multiplication result.
*/
//---------------------------------------TWO BIT Multiplier-------------------------------------------------------------------------------------------
//`timescale 1ns / 1ps
//module add_shift_multiplier(
//    input  [3:0] a,
//    input  [3:0] b,
//    output [7:0] result // final output
//);

//  // Assign the result using the function
//  assign result = result_out(a, b);

//  // Pure combinational function
//      function [7:0] result_out;
//        input [3:0] a;
//        input [3:0] b;
    
//        integer i;
//        reg [7:0] a_extended;
//        reg [7:0] temp_result;
    
//        begin
//          temp_result = 0;
//          a_extended = {4'h0 , a};
//          for (i = 0; i < 4; i = i + 1) begin
//            if (b[i] == 1'b1)begin
//              temp_result = temp_result + (a_extended << i);
//            end
//          end
//          result_out = temp_result; // return final value
//        end
        
//      endfunction
//  endmodule
//-----------------------------------------------------------------------------------------------------------end

/* 
   Multiplier Via the function 
   Here the function is called  two times in the resultant output first(a,b) then ((a,b),c);
*///

`timescale 1ns / 1ps
module add_shift_multiplier#(
parameter input_a_bit = 4,
parameter input_b_bit = 4,
parameter input_c_bit = 4,
parameter output_result_bit = input_a_bit + input_b_bit+input_c_bit

)(
    input  [input_a_bit-1:0] a,
    input  [input_b_bit-1:0] b,
    input  [input_c_bit-1:0] c,
    output [output_result_bit-1:0] result // Max width: 4 + 4 + 4 = 12 bits
);
//-----------------------------------------------------------------------------------------------------------
  // Assign result using function chaining
  assign result = multiply_shift_add(multiply_shift_add(a, b), c); 
//-----------------------------------------------------------------------------------------------------------
  // Reusable shift-and-add multiplication function
  function [output_result_bit-1:0] multiply_shift_add;
    input [output_result_bit-1:0] x; 
    input [input_c_bit -1:0] y; 
    integer i;
    reg [output_result_bit-1:0] x_extended;
    reg [output_result_bit-1:0] temp_result;
    begin
      temp_result = 0;
      x_extended = x; // already zero-extended if input is small
      for (i = 0; i < 4; i = i + 1) begin
            if (y[i] == 1'b1) begin
              temp_result = temp_result + (x_extended << i);
          end
     end
      multiply_shift_add = temp_result;
    end
  endfunction
//-----------------------------------------------------------------------------------------------------------
endmodule


