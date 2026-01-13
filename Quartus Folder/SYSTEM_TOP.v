module SYSTEM_TOP (
    input  wire clk,
    input  wire rst,

    input  wire [3:0] echo,
    output wire [3:0] trig,

    output wire [2:0] LED
);

    // ===============================
    // Ultrasonic distances
    // ===============================
    wire [15:0] d0, d1, d2, d3;

    Ultrasonic_Accelerator US (
        .clk(clk),
        .reset_n(~rst),
        .echo(echo),
        .trig(trig),
        .distance_cm0(d0),
        .distance_cm1(d1),
        .distance_cm2(d2),
        .distance_cm3(d3)
    );

    // ===============================
    // Distance → INT8 scaling
    // ===============================
    wire signed [7:0] x0, x1, x2, x3;

    Distance_To_INT8 S0 (.dist_cm(d0), .x(x0));
    Distance_To_INT8 S1 (.dist_cm(d1), .x(x1));
    Distance_To_INT8 S2 (.dist_cm(d2), .x(x2));
    Distance_To_INT8 S3 (.dist_cm(d3), .x(x3));

    // ===============================
    // Event-driven NN trigger
    // ===============================
    wire start_nn;

    Distance_Change_Detector #(
        .THRESHOLD(16'd20)   // 20 cm sensitivity
    ) START_GEN (
        .clk(clk),
        .rst(rst),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .start_pulse(start_nn)
    );

    // ===============================
    // Neural Network Accelerator
    // ===============================
    wire [1:0] class_id;
    wire done;

    NNA_TOP NN (
        .clk(clk),
        .rst(rst),
        .start(start_nn),

        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),

        .class_id(class_id),
        .neuron_done(done),
        .LED(LED)
    );

endmodule
