module MAC_Controller (
    input  wire clk,
    input  wire rst,
    input  wire start,

    output reg  [1:0] in_idx,
    output reg  [1:0] out_idx,
    output reg        mac_en,
    output reg        done
);

    localparam IDLE      = 3'd0;
    localparam MAC_OP    = 3'd1;
    localparam NEXT_IN   = 3'd2;
    localparam NEXT_OUT  = 3'd3;
    localparam FINISH    = 3'd4;
    localparam DONE_HOLD = 3'd5;

    reg [2:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= IDLE;
            in_idx  <= 2'd0;
            out_idx <= 2'd0;
            mac_en  <= 1'b0;
            done    <= 1'b0;
        end else begin
            case (state)

                IDLE: begin
                    mac_en <= 1'b0;
                    done   <= 1'b0;
                    if (start) begin
                        in_idx  <= 2'd0;
                        out_idx <= 2'd0;
                        state   <= MAC_OP;
                    end
                end

                MAC_OP: begin
                    mac_en <= 1'b1;   
                    state  <= NEXT_IN;
                end

                NEXT_IN: begin
                    mac_en <= 1'b0;
                    if (in_idx == 2'd3) begin
                        state <= NEXT_OUT;
                    end else begin
                        in_idx <= in_idx + 2'd1;
                        state  <= MAC_OP;
                    end
                end

                NEXT_OUT: begin
                    if (out_idx == 2'd2) begin
                        state <= FINISH;
                    end else begin
                        out_idx <= out_idx + 2'd1;
                        in_idx  <= 2'd0;
                        state   <= MAC_OP;
                    end
                end

                FINISH: begin
                    done  <= 1'b1;   
                    state <= DONE_HOLD;
                end

                DONE_HOLD: begin
                    done  <= 1'b0;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
