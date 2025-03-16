/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_cla (
    input  wire [3:0] ui_in,    // Dedicated inputs (used for A and B)
    output wire [3:0] uo_out,   // Dedicated outputs (used for Sum)
    input  wire       uio_in,   // IOs: Input path (used for Cin)
    output wire       uio_out,  // IOs: Output path (unused)
    output wire       uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset_n - low to reset
);

    // Internal signals for CLA
    wire [3:0] A = ui_in[1:0];  // First input operand (lower 2 bits of ui_in)
    wire [3:0] B = ui_in[3:2];  // Second input operand (higher 2 bits of ui_in)
    wire Cin = uio_in;          // Carry-in (single bit from uio_in)
    wire [3:0] Sum;             // Sum output
    wire Cout;                  // Carry-out
    wire [3:0] P, G, C;

    // Propagate and Generate logic
    assign P = A ^ B;  // Propagate
    assign G = A & B;  // Generate

    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);

    // Sum and Carry-out
    assign Sum = P ^ C[3:0];  
    assign Cout = G[3] | (P[3] & C[3]);

    // Map outputs
    assign uo_out = Sum;       // Sum is mapped to uo_out
    assign uio_out = 1'b0;     // Unused
    assign uio_oe  = 1'b0;     // Unused

    // Prevent warnings for unused inputs
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
