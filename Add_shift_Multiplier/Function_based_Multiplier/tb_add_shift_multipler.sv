`timescale 1ns / 1ps
module tb_add_shift_multipler();
parameter input_a_bit = 4;
parameter input_b_bit = 4;
parameter input_c_bit = 4;
parameter output_result_bit = input_a_bit + input_b_bit+input_c_bit;

reg [input_a_bit-1:0] a;
reg [input_b_bit-1:0] b;
reg [input_b_bit-1:0] c;
wire [output_result_bit -1:0] result; // width depend upon a+b

//-------------------------------dut creation------------------------------------------
add_shift_multiplier #(
.input_a_bit(input_a_bit),
.input_b_bit(input_b_bit),
.output_result_bit(output_result_bit)
)
dut_ports(
.a(a),
.b(b),
.c(c),
.result(result)
);
//--------------------------------------------------------------------------------------

initial begin

     for ( int i = 0 ; i <10 ; i = i+1)
     begin
         a    = $urandom_range(0,4); 
         b    = $urandom_range(0,4); 
         c    = $urandom_range(0,4); 
         
         #10;
       end
   #10;
   $finish;
 end
 
//end

initial begin
$monitor ("The output  product : Time = %dns | a = %d | b = %d |c = %d| result = %d " , $time, a,b,c,result);
end
endmodule
