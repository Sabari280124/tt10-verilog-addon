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
    output wire       uio_oe,   // IOs: Enable path (unused)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // Clock (unused)
    input  wire       rst_n     // Reset_n - low to reset (unused)
);

    // Internal signals for CLA
    wire [1:0] A = ui_in[1:0];  // First input operand (lower 2 bits of ui_in)
    wire [1:0] B = ui_in[3:2];  // Second input operand (higher 2 bits of ui_in)
    wire Cin = uio_in;          // Carry-in (single bit from uio_in)
    wire [1:0] Sum;             // Sum output
    wire Carry;                 // Carry-out
    wire [1:0] P, G, C;

    // Propagate and Generate logic
    assign P = A ^ B;           // Propagate
    assign G = A & B;           // Generate

    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign Carry = G[1] | (P[1] & C[1]);

    // Sum computation
    assign Sum = P ^ C;

    // Map outputs
    assign uo_out[1:0] = Sum;   // Map Sum to lower 2 bits of uo_out
    assign uo_out[3:2] = 2'b00; // Unused bits set to 0
    assign uio_out = 1'b0;      // Unused
    assign uio_oe = 1'b0;       // Unused

    // Prevent unused input warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule


