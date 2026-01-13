module NNA_TOP (
    input  wire clk,
    input  wire rst,
    input  wire start,

    // LED output (1-hot)
    output reg  [2:0] LED,

    // 4 inputs (INT8, scaled)
    input  wire signed [7:0] x0,
    input  wire signed [7:0] x1,
    input  wire signed [7:0] x2,
    input  wire signed [7:0] x3,

    output wire [1:0] class_id,
    output wire neuron_done
);

    // =====================================================
    // Internal signals
    // =====================================================
    wire [1:0] in_idx;
    wire [1:0] out_idx;
    wire       mac_en;
    wire       done;

    assign neuron_done = done;

    wire signed [7:0]  w;
    wire signed [15:0] b;

    wire signed [7:0]  x_sel;
    wire signed [31:0] acc_next;

    reg  signed [31:0] acc_reg [0:2];   // accumulator per neuron
    reg  signed [31:0] y_reg   [0:2];   // final neuron outputs

    wire [1:0] class_idx;
    assign class_id = class_idx;

    integer i;

    // =====================================================
    // Input MUX (4 → 1)
    // =====================================================
    assign x_sel =
        (in_idx == 2'd0) ? x0 :
        (in_idx == 2'd1) ? x1 :
        (in_idx == 2'd2) ? x2 :
                           x3;

    // =====================================================
    // Weight & Bias ROM
    // =====================================================
    Weight_Memory W_ROM (
        .in_idx (in_idx),
        .out_idx(out_idx),
        .W      (w)
    );

    Bias_Memory B_ROM (
        .out_idx(out_idx),
        .B      (b)
    );

    // =====================================================
    // Controller FSM
    // =====================================================
    MAC_Controller CTRL (
        .clk    (clk),
        .rst    (rst),
        .start  (start),
        .in_idx (in_idx),
        .out_idx(out_idx),
        .mac_en (mac_en),
        .done   (done)
    );

    // =====================================================
    // MAC Unit
    // =====================================================
    MAC MAC_U (
        .clk     (clk),
        .rst     (rst),
        .enable  (mac_en),
        .x       (x_sel),
        .w       (w),
        .acc_in  (acc_reg[out_idx]),
        .acc_out (acc_next)
    );

    // =====================================================
    // Accumulator (BIAS ONCE + CLEAN RESET PER NEURON)
    // =====================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 3; i = i + 1)
                acc_reg[i] <= 32'sd0;
        end else if (mac_en) begin
            if (in_idx == 2'd0)
                // load bias ONLY ONCE per neuron
                acc_reg[out_idx] <= {{16{b[15]}}, b};
            else
                // accumulate x*w
                acc_reg[out_idx] <= acc_next;
        end
    end

    // =====================================================
    // Store final neuron outputs 
    // =====================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 3; i = i + 1)
                y_reg[i] <= 32'sd0;
        end else if (done) begin
            // ReLU applied here
            y_reg[0] <= (acc_reg[0] < 0) ? 32'sd0 : acc_reg[0];
            y_reg[1] <= (acc_reg[1] < 0) ? 32'sd0 : acc_reg[1];
            y_reg[2] <= (acc_reg[2] < 0) ? 32'sd0 : acc_reg[2];
        end
    end

    // =====================================================
    // Argmax
    // =====================================================
    Argmax3 ARGMAX (
        .clk       (clk),
        .rst       (rst),
        .valid     (done),
        .y0        (y_reg[0]),
        .y1        (y_reg[1]),
        .y2        (y_reg[2]),
        .class_idx (class_idx)
    );

    // =====================================================
    // LED Output (1-hot)
    // =====================================================
    always @(*) begin
        case (class_id)
            2'd0: LED = 3'b001;
            2'd1: LED = 3'b010;
            2'd2: LED = 3'b100;
            default: LED = 3'b000;
        endcase
    end

endmodule
