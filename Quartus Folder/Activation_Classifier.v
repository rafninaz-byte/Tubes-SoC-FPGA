module Activation_Classifier #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 32
)(
    input wire clk,
    input wire reset_n,
    input wire enable,
    input wire signed [ACC_WIDTH-1:0] mac_results [0:2],
    output reg [2:0] classification,  // [Safe, Warning, Danger]
    output reg valid_out
);

// Activation outputs (after ReLU)
reg signed [DATA_WIDTH-1:0] activated [0:2];

// ReLU activation function
function signed [DATA_WIDTH-1:0] relu_quantize;
    input signed [ACC_WIDTH-1:0] value;
    reg signed [DATA_WIDTH-1:0] quantized;
begin
    // Apply ReLU
    if (value[ACC_WIDTH-1])  // Check sign bit
        quantized = 0;  // Negative → 0
    else begin
        // Simple quantization (scale down and clip)
        // Adjust scaling factor based on your training
        quantized = (value >>> 5);  // Scale down by 32
        if (quantized > 127) quantized = 127;
        if (quantized < -128) quantized = -128;
    end
    relu_quantize = quantized;
end
endfunction

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        classification <= 3'b001;  // Default: Safe
        valid_out <= 0;
        activated[0] <= 0;
        activated[1] <= 0;
        activated[2] <= 0;
    end else if (enable) begin
        // Apply activation to each neuron output
        activated[0] <= relu_quantize(mac_results[0]);
        activated[1] <= relu_quantize(mac_results[1]);
        activated[2] <= relu_quantize(mac_results[2]);
        
        // Find maximum (argmax) for classification
        if (activated[0] >= activated[1] && activated[0] >= activated[2])
            classification <= 3'b001;  // Safe (neuron 0)
        else if (activated[1] >= activated[0] && activated[1] >= activated[2])
            classification <= 3'b010;  // Warning (neuron 1)
        else
            classification <= 3'b100;  // Danger (neuron 2)
        
        valid_out <= 1;
    end else begin
        valid_out <= 0;
    end
end

endmodule