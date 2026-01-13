module nn_controller (
    input  wire clk,
    input  wire rst,
    input  wire start,

    input  wire signed [7:0]  x_in,
    input  wire signed [7:0]  w_in,
    input  wire signed [15:0] b_in,

    output reg  [1:0] in_idx,
    output reg  [1:0] out_idx,
    output reg  done,

    output reg  signed [31:0] acc
);

    IDLE,
    LOAD,
    MAC,
    NEXT_IN,
    NEXT_OUT,
    DONE

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state   <= IDLE;
        in_idx  <= 0;
        out_idx <= 0;
        acc     <= 0;
        done    <= 0;
    end else begin
        case (state)

        IDLE: begin
            done <= 0;
            if (start) begin
                in_idx  <= 0;
                out_idx <= 0;
                acc     <= 0;
                state   <= LOAD;
            end
        end

        LOAD: begin
            acc <= {{16{b_in[15]}}, b_in}; // sign extend bias
            state <= MAC;
        end

        MAC: begin
            acc <= acc + (x_in * w_in);
            state <= NEXT_IN;
        end

        NEXT_IN: begin
            if (in_idx == 2'd3) begin
                state <= NEXT_OUT;
            end else begin
                in_idx <= in_idx + 1;
                state <= MAC;
            end
        end

        NEXT_OUT: begin
            if (out_idx == 2'd2) begin
                state <= DONE;
            end else begin
                out_idx <= out_idx + 1;
                in_idx  <= 0;
                acc     <= 0;
                state   <= LOAD;
            end
        end

        DONE: begin
            done  <= 1;
            state <= IDLE;
        end

        endcase
    end
end

endmodule
