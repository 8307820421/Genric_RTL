`timescale 1ns / 1ps




module tb_fibonacci_series();

    parameter N = 4;
    parameter DATA_WIDTH = 32;

    wire [N*DATA_WIDTH-1:0] fib_out;

    // Instantiate the parallel Fibonacci generator
    fibonacci_series  #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .fib_out(fib_out)
    );

    // Local unpacked array for accessing each Fibonacci number
    wire [DATA_WIDTH-1:0] fib_unpacked [0:N-1];

    // Unpack the flattened bus into array
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : unpack
            assign fib_unpacked[i] = fib_out[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH];
        end
    endgenerate

    initial begin
        #10;
        $display("Fibonacci Sequence (First %0d Terms):", N);
        for (int j = 0; j < N; j = j + 1) begin
            $display("fib[%0d] = %0d", j, fib_unpacked[j]);
        end
        #10 $finish;
    end

endmodule



