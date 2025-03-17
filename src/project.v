/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_cla (
    input  wire [7:0] ui_in,    // Dedicated inputs for A and B
    output wire [3:0] uo_out,   // Outputs for Sum
    input  wire [7:0] uio_in,    // Carry-in adjusted to 8 bits
    output wire [7:0] uio_out,   // Unused output (changed to 8 bits)
    output wire [7:0] uio_oe,    // Unused enable (changed to 8 bits)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // Unused clock
    input  wire       rst_n     // Unused reset (active low)
);

    // Internal signals for CLA
    wire [3:0] A = ui_in[3:0];  // Lower 4 bits of ui_in for A
    wire [3:0] B = ui_in[7:4];  // Upper 4 bits of ui_in for B
    wire Cin = uio_in[0];       // Carry-in (only the lowest bit of uio_in is used)
    wire [3:0] Sum;             // Sum output
    wire Cout;                  // Carry-out
    wire [3:0] P, G, C;         // Propagate, Generate, and Carry

    // Propagate and Generate logic
    assign P = A ^ B;           // Propagate
    assign G = A & B;           // Generate

    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);

    // Sum computation
    assign Sum = P ^ C;

    // Map outputs
    assign uo_out = Sum;        // Map Sum to uo_out
    assign uio_out = 8'b0;      // Unused output (set to 8 bits)
    assign uio_oe = 8'b0;       // Unused enable (set to 8 bits)

    // Prevent warnings for unused inputs
    wire _unused = &{ena, clk, rst_n};

endmodule
