module Input_Buffer #(
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire reset_n,
    input wire load_en,
    input wire signed [DATA_WIDTH-1:0] sensor0,
    input wire signed [DATA_WIDTH-1:0] sensor1,
    input wire signed [DATA_WIDTH-1:0] sensor2,
    input wire signed [DATA_WIDTH-1:0] sensor3,
    output reg signed [DATA_WIDTH-1:0] buffer_out [0:3]
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        buffer_out[0] <= 0;
        buffer_out[1] <= 0;
        buffer_out[2] <= 0;
        buffer_out[3] <= 0;
    end else if (load_en) begin
        buffer_out[0] <= sensor0;
        buffer_out[1] <= sensor1;
        buffer_out[2] <= sensor2;
        buffer_out[3] <= sensor3;
    end
end

endmodule