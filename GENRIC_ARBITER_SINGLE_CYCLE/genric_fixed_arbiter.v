`timescale 1ns / 1ps

/*
  Module Name : genric_fixed_arbiter
  Description : This arbiter will work for every parameters.
  Operators : 1) OR (bitwise) 2) bitwise AND .

  Note : To see how this arbiter is working you can look at the screenshot where 32'd3 testcase developed.
*/

module genric_fixed_arbiter  #(
           parameter N = 32
)(
     input  [N-1:0] req_i,
     output [N-1:0] grant_o
    
);

wire [N-1:0] priority_q ;

assign priority_q[0] = 1'b0; // initial value

for (genvar i = 0; i < N-1 ; i= i+1) // loop N-1 as 2bit here
begin
    assign priority_q[i+1] = priority_q[i] | req_i[i];
end

wire [N-1:0] inverse ;
assign inverse = ~priority_q; // 

assign grant_o = inverse & req_i;

endmodule

/* Example :
req_i = 2'b01; (priority of zero set) (as at 0 th index it is 1'b1)
expected output = 2'b01;

lets match the expected output :
priority_q[0] = 1'b0;
priority_q[1] = 1'b0;
priority_q = {1'b1,1'b0}; // as 2bit


inverse =  2'b01; (~priority_q).
grant_o = 2'b01 & 01 --> 2'01 (priority of zeroth index  active).
*/
