# Folder Name    : Genric_Fibonacci_Series

# Description    : 
                   
                   This  module contain the Fibonacci sequence (0,1,1,2,3,5,8,13---) based upon the 'N' . Here , this module print the all fibonaaci sequence parallely 
                   For individually access the fibonacci series you need to work with sequential and clock based approach.

Notes           :

                1) The for loop from Higher order paramteric (N down to Zero ) will not work with respect to the for loop genric RTL . As , it cause synthesiability issues.

                2) Verilog for Loop (Simulation vs. Synthesis):

                   In Verilog, for loops are often used for simulation purposes to generate repetitive structures or operations. However, when synthesizing to hardware, 
                   synthesizers like Vivado generally expect a fixed, deterministic structure that can be directly translated into hardware resources such as registers, logic gates, 
                   and connections.

                  The for loop in Verilog, when used in a generate block, typically tries to create a set of hardware resources based on a loop parameter. If the loop is from MSB to LSB 
                  (Most Significant Bit to Least Significant Bit), it introduces a dynamic nature that may cause the synthesizer difficulty in generating fixed hardware resources, 
                  as it’s not always possible to "unroll" this loop in a straightforward way for hardware.

              3) Order of Loop Execution (MSB to LSB):

                In hardware synthesis, the order in which operations or bits are processed is crucial. A for loop from MSB to LSB may introduce dependencies between bits that make 
                the logic complex to implement. For example, if you're synthesizing a parallel shift register or a series of logic gates, processing the MSB first could introduce timing 
                and routing challenges.

               If the for loop is implemented from MSB down to LSB, the synthesizer might struggle to break the logic down into simple, parallel, or sequential operations. This could 
               lead to complex dependencies between hardware resources, making it non-synthesizable or inefficient.

              
