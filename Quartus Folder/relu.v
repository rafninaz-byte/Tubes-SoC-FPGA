module relu (
    input  wire clk,
    input  wire rst,
    input  wire signed [31:0] x,
    output reg  signed [31:0] y
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            y <= 32'sd0;
        else
            y <= (x < 0) ? 32'sd0 : x;
    end

endmodule
