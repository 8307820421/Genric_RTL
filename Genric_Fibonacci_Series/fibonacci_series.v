/*
   Module NBame ---> Fibnoacci Series
   Description ----> In this module the output of next bit index is the sum of present value at (present index)
                     and past value (at partcular index).
                     Here, we need to hold the two index values in intermediate

);
     wire [DATA_WIDTH-1:0] fib [0:N-1] ; // Output array of Fibonacci numbers
                     register . f[0] and f[1].
                     Because the f[2] is the sum of f[0] + f[1].
                     similarly   f[3] is f[1] + f[2]. and so on
*/
//module fibonacci_series #(
//    parameter N = 4,
//    parameter DATA_WIDTH = 32
//)(
//    input reset ,
//    output  [N*DATA_WIDTH-1:0] fib_out
//);

//    // Internal 1D array
//     wire [DATA_WIDTH-1:0] fib_temp     [0:N-1];
    
     

//     assign fib_temp[0]  = 32'd0;
//     assign fib_temp[1]  = 32'd1;
     
   
//genvar i;
//generate
//     for ( i= 2  ;  i < N-1 ; i = i+1)begin : fib_temp_gnerate  
//            assign fib_temp[i]    =  fib_temp[i-2] + fib_temp[i-1]; 

            
//        end
//endgenerate

//genvar j;
//generate
//        for ( i = 0  ;  i < N-1 ; i = i+1)begin : fib_temp_store  
            //fib_out[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH] = fib_temp[i]
//        end
//endgenerate





//endmodule

module fibonacci_series #(
    parameter N = 4,
    parameter DATA_WIDTH = 8 //  bits
)(
    output [N*DATA_WIDTH-1:0] fib_out
);

    // Internal 1D array
    wire [DATA_WIDTH-1:0] fib_internal [0:N-1];

    // Assign base values
    assign fib_internal[0] = 0;
    assign fib_internal[1] = 1;

    // Generate Fibonacci sequence
    genvar i;
    generate
        for (i = 2; i < N; i = i + 1) begin : fib_generate
            assign fib_internal[i] = fib_internal[i-1] + fib_internal[i-2];
        end
    endgenerate

    // Flatten array to single output vector
    generate
        for (i = 0; i < N; i = i + 1) begin : flatten_output
            assign fib_out[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH] = fib_internal[i];
        end
    endgenerate

endmodule


