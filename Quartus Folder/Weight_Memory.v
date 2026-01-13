module Weight_Memory (
    input  wire [1:0] in_idx,    // 0..3
    input  wire [1:0] out_idx,   // 0..2
    output reg  signed [7:0] W
);

always @(*) begin
    W = 8'sd0;  // <<< DEFAULT (CRITICAL)

    case (out_idx)
        2'd0: case (in_idx)
            2'd0: W = 8'sd14;
            2'd1: W = -8'sd24;
            2'd2: W = 8'sd30;
            2'd3: W = -8'sd117;
        endcase

        2'd1: case (in_idx)
            2'd0: W = 8'sd99;
            2'd1: W = 8'sd116;
            2'd2: W = 8'sd70;
            2'd3: W = 8'sd109;
        endcase

        2'd2: case (in_idx)
            2'd0: W = 8'sd4;
            2'd1: W = 8'sd40;
            2'd2: W = 8'sd127;
            2'd3: W = 8'sd126;
        endcase
    endcase
end

endmodule
