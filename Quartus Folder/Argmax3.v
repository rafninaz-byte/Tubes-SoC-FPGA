module Argmax3 (
    input  wire clk,
    input  wire rst,
    input  wire valid,   

    input  wire signed [31:0] y0,
    input  wire signed [31:0] y1,
    input  wire signed [31:0] y2,

    output reg  [1:0] class_idx
);

    reg [1:0] max_idx;

    always @(*) begin
        if (y0 >= y1 && y0 >= y2)
            max_idx = 2'd0;
        else if (y1 >= y2)
            max_idx = 2'd1;
        else
            max_idx = 2'd2;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            class_idx <= 2'd0;
        else if (valid)
            class_idx <= max_idx;
    end

endmodule
