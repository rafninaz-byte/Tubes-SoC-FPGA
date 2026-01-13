module Distance_To_INT8 (
    input  wire [15:0] dist_cm,
    output wire signed [7:0] x
);
    // Assume max distance = 400 cm
    wire [15:0] clipped = (dist_cm > 400) ? 400 : dist_cm;

    // Scale 0–400 cm → 0–127
    assign x = clipped[15:2];   
endmodule
