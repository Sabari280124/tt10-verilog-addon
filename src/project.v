/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_cla (
    input  wire [1:0] ui_in,    // Dedicated inputs for A and B
    output wire [1:0] uo_out,   // Dedicated outputs for sum and carry
    input  wire       uio_in,   // IOs: Input path for Cin
    output wire       uio_out,  // IOs: Output path (unused)
    output wire       uio_oe,   // IOs: Enable path (unused)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // Clock (unused)
    input  wire       rst_n     // Reset_n (unused)
);

    // Internal signals for CLA
    wire a = ui_in[0];          // First input operand
    wire b = ui_in[1];          // Second input operand
    wire Cin = uio_in;          // Carry-in (single bit from uio_in)
    wire Sum;                   // Sum output
    wire Carry;                 // Carry-out

    // Logic for Carry Lookahead Adder
    assign Sum = a ^ b ^ Cin;           // Compute Sum
    assign Carry = (a & b) | (a & Cin) | (b & Cin); // Compute Carry-out

    // Map outputs to match the Tiny Tapeout pinout
    assign uo_out[0] = Sum;             // Map Sum to uo[0]
    assign uo_out[1] = Carry;           // Map Carry to uo[1]
    assign uio_out = 1'b0;              // Unused
    assign uio_oe  = 1'b0;              // Unused

    // Prevent warnings for unused inputs
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

