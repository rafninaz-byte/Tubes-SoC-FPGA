module Bias_Memory (
    input  wire [1:0] out_idx,
    output reg  signed [15:0] B
);

always @(*) begin
    case (out_idx)
        2'd0: B = 16'sd19139;
        2'd1: B = 16'sd18526;
        2'd2: B = 16'sd6599;
        default: B = 0;
    endcase
end

endmodule
