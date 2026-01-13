module MAC (
    input  wire clk,
    input  wire rst,
    input  wire enable,

    input  wire signed [7:0]  x,
    input  wire signed [7:0]  w,
    input  wire signed [31:0] acc_in,

    output reg  signed [31:0] acc_out
);

    wire signed [15:0] mul;
    assign mul = x * w;

    always @(posedge clk or posedge rst) begin
        if (rst)
            acc_out <= 32'sd0;
        else if (enable)
            acc_out <= acc_in + mul;
    end

endmodule
