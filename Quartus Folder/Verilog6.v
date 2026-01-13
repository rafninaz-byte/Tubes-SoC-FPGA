module NNA_TOP #(
    parameter DATA_WIDTH = 8,
    parameter WEIGHT_FILE = "weights_init.mem"  // Pre-trained weights file
)(
    input wire clk,
    input wire reset_n,
    input wire start,
    
    // Sensor inputs (4 ultrasonic distances in cm, 0-255 range)
    input wire [DATA_WIDTH-1:0] sensor0,  // Front
    input wire [DATA_WIDTH-1:0] sensor1,  // Left
    input wire [DATA_WIDTH-1:0] sensor2,  // Right
    input wire [DATA_WIDTH-1:0] sensor3,  // Rear
    
    // Output classification (one-hot)
    output reg [2:0] classification,  // [Safe, Warning, Danger]
    output reg valid,
    output wire ready
);

// ============================================
// Internal Signals
// ============================================
wire [DATA_WIDTH-1:0] input_buffer [0:3];
wire [DATA_WIDTH-1:0] weight_bus [0:2];  // 3 neurons x 4 weights each
wire [DATA_WIDTH-1:0] bias_bus [0:2];
wire mac_enable, accum_clear, act_enable;
wire [ACC_WIDTH-1:0] mac_results [0:2];
wire [DATA_WIDTH-1:0] activated_outputs [0:2];
wire [1:0] weight_addr;
wire [1:0] neuron_sel;

// ============================================
// Submodule Instantiations
// ============================================

// Input Buffer (stores 4 sensor readings)
Input_Buffer u_input_buffer (
    .clk(clk),
    .reset_n(reset_n),
    .load_en(start),
    .sensor0(sensor0),
    .sensor1(sensor1),
    .sensor2(sensor2),
    .sensor3(sensor3),
    .buffer_out(input_buffer)
);

// Weight Memory (12 weights: 3 neurons × 4 inputs)
Weight_Memory u_weight_memory (
    .clk(clk),
    .reset_n(reset_n),
    .write_en(config_write),
    .write_addr(config_addr),
    .write_data(config_data),
    .read_addr(weight_addr),
    .neuron_sel(neuron_sel),
    .weight_out(weight_bus)
);

// Bias Memory (3 biases for 3 neurons)
Bias_Memory u_bias_memory (
    .clk(clk),
    .reset_n(reset_n),
    .write_en(config_write),
    .write_addr(config_addr),
    .write_data(config_data),
    .bias_out(bias_bus)
);

// MAC Array (3 parallel MACs for 3 output neurons)
MAC_Array #(
    .NUM_UNITS(3),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
) u_mac_array (
    .clk(clk),
    .reset_n(reset_n),
    .enable(mac_enable),
    .clear(accum_clear),
    .weights(weight_bus),
    .activations(input_buffer),  // All 4 inputs to each neuron
    .biases(bias_bus),
    .results(mac_results)
);

// Activation & Classification
Activation_Classifier u_activation (
    .clk(clk),
    .reset_n(reset_n),
    .enable(act_enable),
    .mac_results(mac_results),
    .classification(classification),
    .valid_out(valid_out)
);

// Control FSM
Control_FSM u_control_fsm (
    .clk(clk),
    .reset_n(reset_n),
    .start(start),
    .mac_enable(mac_enable),
    .accum_clear(accum_clear),
    .act_enable(act_enable),
    .weight_addr(weight_addr),
    .neuron_sel(neuron_sel),
    .ready(ready)
);

endmodule