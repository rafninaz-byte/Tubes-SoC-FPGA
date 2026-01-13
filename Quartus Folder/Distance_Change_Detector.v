module Distance_Change_Detector #(
    parameter THRESHOLD = 16'd20   // cm change required to trigger NN
)(
    input  wire clk,
    input  wire rst,

    input  wire [15:0] d0,
    input  wire [15:0] d1,
    input  wire [15:0] d2,
    input  wire [15:0] d3,

    output reg  start_pulse
);

    reg [15:0] prev_d0, prev_d1, prev_d2, prev_d3;

    wire change_detected;

    assign change_detected =
        ( (d0 > prev_d0 ? d0 - prev_d0 : prev_d0 - d0) > THRESHOLD ) ||
        ( (d1 > prev_d1 ? d1 - prev_d1 : prev_d1 - d1) > THRESHOLD ) ||
        ( (d2 > prev_d2 ? d2 - prev_d2 : prev_d2 - d2) > THRESHOLD ) ||
        ( (d3 > prev_d3 ? d3 - prev_d3 : prev_d3 - d3) > THRESHOLD );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_d0 <= 0;
            prev_d1 <= 0;
            prev_d2 <= 0;
            prev_d3 <= 0;
            start_pulse <= 0;
        end else begin
            start_pulse <= change_detected;

            prev_d0 <= d0;
            prev_d1 <= d1;
            prev_d2 <= d2;
            prev_d3 <= d3;
        end
    end

endmodule
