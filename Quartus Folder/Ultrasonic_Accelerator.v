module Ultrasonic_Accelerator (
    input  wire        clk,
    input  wire        reset_n,

    input  wire [3:0]  echo,
    output reg  [3:0]  trig,

    output reg [15:0] distance_cm0,
    output reg [15:0] distance_cm1,
    output reg [15:0] distance_cm2,
    output reg [15:0] distance_cm3
);

    // =====================================================
    // Parameters
    // =====================================================
    parameter TRIG_PULSE = 500;          // ~10 us @ 50 MHz
    parameter MAX_ECHO   = 1_500_000;    // ~25 ms timeout

    // =====================================================
    // FSM state encoding
    // =====================================================
    localparam IDLE   = 2'd0;
    localparam TRIG_S = 2'd1;
    localparam WAIT_E = 2'd2;
    localparam NEXT   = 2'd3;

    // FSM register (ATTRIBUTE ADDED)
    (* fsm_encoding = "sequential" *)
    reg [1:0] fsm_state;

    // =====================================================
    // Internal registers
    // =====================================================
    reg [1:0]  sensor_id;
    reg [15:0] trig_cnt;
    reg [21:0] echo_cnt;
    reg        echo_d;

    reg [21:0] echo_width [0:3];

    // =====================================================
    // FSM + Control Logic
    // =====================================================
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fsm_state <= IDLE;
            sensor_id <= 2'd0;
            trig      <= 4'b0000;
            trig_cnt  <= 16'd0;
            echo_cnt  <= 22'd0;
            echo_d    <= 1'b0;
        end else begin
            case (fsm_state)

                // -----------------------------------------
                IDLE: begin
                    trig <= (4'b0001 << sensor_id);
                    trig_cnt <= 16'd0;
                    fsm_state <= TRIG_S;
                end

                // -----------------------------------------
                TRIG_S: begin
                    if (trig_cnt >= TRIG_PULSE) begin
                        trig <= 4'b0000;
                        echo_cnt <= 22'd0;
                        fsm_state <= WAIT_E;
                    end else begin
                        trig_cnt <= trig_cnt + 1'b1;
                    end
                end

                // -----------------------------------------
                WAIT_E: begin
                    echo_d <= echo[sensor_id];

                    if (echo[sensor_id]) begin
                        echo_cnt <= echo_cnt + 1'b1;
                    end else if (echo_d) begin
                        echo_width[sensor_id] <= echo_cnt;
                        fsm_state <= NEXT;
                    end else if (echo_cnt >= MAX_ECHO) begin
                        echo_width[sensor_id] <= 22'd0;
                        fsm_state <= NEXT;
                    end
                end

                // -----------------------------------------
                NEXT: begin
                    sensor_id <= (sensor_id == 2'd3) ? 2'd0 : sensor_id + 2'd1;
                    fsm_state <= IDLE;
                end

                default: fsm_state <= IDLE;

            endcase
        end
    end

    // =====================================================
    // Distance calculation (cm)
    // =====================================================
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            distance_cm0 <= 16'd0;
            distance_cm1 <= 16'd0;
            distance_cm2 <= 16'd0;
            distance_cm3 <= 16'd0;
        end else begin
            distance_cm0 <= echo_width[0] / 32'd2900;
            distance_cm1 <= echo_width[1] / 32'd2900;
            distance_cm2 <= echo_width[2] / 32'd2900;
            distance_cm3 <= echo_width[3] / 32'd2900;
        end
    end

endmodule
