/*
   Module Name is : Hamming_code_decoder_rx
   Description    : This module developed the single and double bit error detection and
                    correction techniques based upon the hamming code encoder tx output.
                    
   Note          : 1) Here I did not make top module but tested with testcases based
                      upon the testbench developed in SV.
                   2) Here I just flip the bit position to see the real output of information
                     bit vector that is extracted at decoder side.
                  3) Here generate  if construct used hence the syntax taken care.
                  4) Mostly , algo if poosible develop using function . Just know what 
                     step to follow.
  Application   : This module can also used to encrypt and decrypt the data from external 
                  interface.
*/
/*-----------------------------------------------------------------------------------------*/

module hamming_code_decoder_rx #(
  parameter K       = 8, //Information bit vector size
  parameter LATENCY = 0, //0: no latency (combinatorial design)
                         //1: registered outputs
                         //2: registered inputs+outputs
  parameter P0_LSB  = 1, //0: p0 is located at MSB
                         //1: p0 is located at LSB

  //These should be localparams
  parameter m = calculate_m(K),
  parameter n = m + K
)
(
  //clock/reset ports (if LATENCY > 0)
  input              rst_ni,     //asynchronous reset
  input              clk_i,      //clock input
  input              clkena_i,   //clock enable input

  //data ports
  input      [n  :0] d_i,        //encoded code word input
  output reg [K-1:0] q_o,        //information bit vector output
  output reg [m  :0] syndrome_o, //syndrome vector output

  //flags
  output reg         sb_err_o,   //single bit error detected
  output reg         db_err_o,   //double bit error detected
  output reg         sb_fix_o    //repaired error in the information bits
);

//---------------------------------------------------------
// Functions
//---------------------------------------------------------
/*function to calcualte the parity width */
function integer calculate_m(input integer k);
  integer m;
begin
  m=1;
  while (2**m < m+k+1)begin
   m = m+1;
  calculate_m = m;
  end 
 end
endfunction //calculate_m

/*-----------------------------------------------------------------------------------------*/
/*-------------------function to calculate syndrome----------------------------------------------------------------------*/
function [m:1] calculate_syndrome(input [n:0] cw);
  integer p_idx, cw_idx;
begin
    //clear syndrome
    calculate_syndrome = 0;

    for (p_idx =1; p_idx <=m; p_idx = p_idx+1)  //parity vector index
    for (cw_idx=1; cw_idx<=n; cw_idx = cw_idx+1) //code-word index
      if (|(2**(p_idx-1) & cw_idx)) calculate_syndrome[p_idx] = calculate_syndrome[p_idx] ^ cw[cw_idx];
end
endfunction //calculate_syndrome
/*-----------------------------------------------------------------------------------------*/

/*----------------------function to flip the bit position if error-------------------------*/
function [n:0] correct_codeword ;
input [n:0] cw;
input [m:1] syndrome;
 begin
    /*
      Correct all bits, including parity bits and extended parity bit.
      This simplifies this section and keeps the logic simple.

      The parity-bits are not used when extracting the information bits vector.
      Dead-logic-removal gets rid of the generated logic for the parity bits.
    */

    //assign code word
    correct_codeword = cw;

    //then invert bit indicated by syndrome
    correct_codeword[syndrome] = ~correct_codeword[syndrome];
   end
endfunction //correct_codeword
/*-----------------------------------------------------------------------------------------*/

/*----------------Function to extract the information bit vector---------------------------*/
function [K-1:0] extract_q(input [n:0] cw);
  integer bit_idx, cw_idx;
begin
    //This function extracts the information bits vector from the codeword
    //information bits are stored in non-power-of-2 locations

    bit_idx=0; //information bit vector index
    for (cw_idx=1; cw_idx<=n; cw_idx = cw_idx+1) begin//codeword index
      if (2**$clog2(cw_idx) != cw_idx) begin
        extract_q[bit_idx] = cw[cw_idx];
        bit_idx            = bit_idx+1;
       end
   end
end
endfunction //extract_q
/*-----------------------------------------------------------------------------------------*/

/*--------------------------------function for power of Two -------------------------------*/
function is_power_of_2(input integer arg);
    is_power_of_2 = (arg & (arg-1)) == 0;
endfunction

/*-----------------------------------------------------------------------------------------*/

/*-------------------------Function to check the error----------------------------------------------------------------*/
function information_error(input [m:1] syndrome);
begin
    //This function checks if an error was detected/corrected in the information bits
    information_error = |syndrome & !is_power_of_2(syndrome);
end
endfunction //information_error

/*-----------------------------------------------------------------------------------------*/

/*-------------------------------Intermediate register--------------------------------------*/
/// Variables 
//---------------------------------------------------------
wire          parity;      //full codeword parity check
reg          parity_reg;
wire  [m  :1] syndrome;    //bit error indication/location
reg[m  :1]   syndrome_reg;
wire  [n  :0] cw_fixed;    //corrected code word
  
wire  [n  :0] d;
reg        [n  :0] d_reg;
wire  [K-1:0] q;
wire          sb_err;
wire          db_err;
wire          sb_fix;

//-------------------------------------------------------------------------------------------------
// Module Body
//------------------------------------------------------------------------------------------

/*
  Below diagram indicates the locations of the parity and data bits
  in the final 'p' vector.
  It also shows what databits each parity bit operates on

    1  2  3  4  5  6  7  8  9 10 11 12 13  14  15
   p1 p2 d1 p4 d2 d3 d4 p8 d5 d6 d7 d8 d9 d10 d11
p1  x     x     x     x     x     x     x       x
p2     x  x        x  x        x  x         x   x
p4           x  x  x  x              x  x   x   x
p8                       x  x  x  x  x  x   x   x
*/
/*------------------------Steps-----------------------------------------------------------------*/
//Step 1: Locate Parity bit
assign d = P0_LSB ? d_i : {d_i[n-1:0],d_i[n]};

//Step 2: Calculate code word parity
assign parity = ^d;

//Step 3: Calculate syndrome
assign syndrome = calculate_syndrome(d);

/*----------------------generate if construct-------------------------------------------------*/

//Step 4: Generate intermediate registers (if any)
generate
  if (LATENCY > 1) begin : gen_regi
    always @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        d_reg        <= {n+1{1'b0}};
        parity_reg   <= 1'b0;
        syndrome_reg <= {m{1'b0}};
      end else if (clkena_i) begin
        d_reg        <= d;
        parity_reg   <= parity;
        syndrome_reg <= syndrome;
      end
    end
  end else begin : gen_noregi
    always @(*) begin
      d_reg        = d;
      parity_reg   = parity;
      syndrome_reg = syndrome;
    end
  end
endgenerate

// Step 5: Correct erroneous bit (if any)
assign cw_fixed = correct_codeword(d_reg, syndrome_reg);

// Step 6: Extract information bits vector
assign q = extract_q(cw_fixed);

// Step 7: Generate status flags
assign sb_err =  parity_reg & |syndrome_reg;
assign db_err = ~parity_reg & |syndrome_reg;
assign sb_fix =  parity_reg & |information_error(syndrome_reg);

// Step 8: Generate output registers (if required)
generate
  if (LATENCY > 0) begin : gen_rego //
    always @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        q_o        <= {K{1'b0}};
        syndrome_o <= {m+1{1'b0}};
        sb_err_o   <= 1'b0;
        db_err_o   <= 1'b0;
        sb_fix_o   <= 1'b0;
      end else if (clkena_i) begin
        q_o        <= q;
        syndrome_o <= P0_LSB ? {syndrome_reg, parity_reg} : {parity_reg, syndrome_reg};
        sb_err_o   <= sb_err;
        db_err_o   <= db_err;
        sb_fix_o   <= sb_fix;
      end
    end
  end else begin : gen_norego
    always @(*) begin
      q_o        = q;
      syndrome_o = P0_LSB ? {syndrome_reg, parity_reg} : {parity_reg, syndrome_reg};
      sb_err_o   = sb_err;
      db_err_o   = db_err;
      sb_fix_o   = sb_fix;
    end
  end
endgenerate
endmodule