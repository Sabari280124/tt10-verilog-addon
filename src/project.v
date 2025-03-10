


/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_cla_8bit (
    input  wire [7:0] ui_in,    // Dedicated inputs (used for A and B)
    output wire [7:0] uo_out,   // Dedicated outputs (used for Sum)
    input  wire [7:0] uio_in,   // IOs: Input path (used for Cin)
    output wire [7:0] uio_out,  // IOs: Output path (unused)
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Internal signals for CLA
    wire [7:0] A = ui_in;       // First input operand
    wire [7:0] B = uio_in[7:0]; // Second input operand
    wire Cin = uio_in[0];       // Carry-in (using least significant bit of `uio_in`)
    wire [7:0] Sum;             // Sum output
    wire Cout;                  // Carry-out
    wire [7:0] P, G, C;

    // Propagate and Generate logic
    assign P = A ^ B;  // Propagate
    assign G = A & B;  // Generate

    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    // Sum and Carry-out
    assign Sum = P ^ C[7:0];  
    assign Cout = G[7] | (P[7] & C[7]);

    // Map outputs
    assign uo_out = Sum;       // Sum is mapped to uo_out
    assign uio_out = 8'b0;     // Unused
    assign uio_oe  = 8'b0;     // Unused

    // Prevent warnings for unused inputs
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
