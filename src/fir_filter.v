module fir_filter(
    input                  clk,
    input                  reset,
    input                  enable,
    input  signed [15:0]   data_in,
    output signed [31:0]   data_out
);
    parameter N1 = 8;
    parameter N2 = 16;
    parameter N3 = 32;

    reg signed [N3-1:0] output_data_reg;
    reg signed [N2-1:0] samples [0:6];

    wire signed [N1-1:0] b [0:7];
    assign b[0]=8'h10; assign b[1]=8'h10; assign b[2]=8'h10; assign b[3]=8'h10;
    assign b[4]=8'h10; assign b[5]=8'h10; assign b[6]=8'h10; assign b[7]=8'h10;

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 7; i = i+1) samples[i] <= 0;
            output_data_reg <= 0;
        end
        else if (enable) begin
            output_data_reg <= b[0]*data_in    + b[1]*samples[0]
                             + b[2]*samples[1] + b[3]*samples[2]
                             + b[4]*samples[3] + b[5]*samples[4]
                             + b[6]*samples[5] + b[7]*samples[6];
            samples[0] <= data_in;
            samples[1] <= samples[0];
            samples[2] <= samples[1];
            samples[3] <= samples[2];
            samples[4] <= samples[3];
            samples[5] <= samples[4];
            samples[6] <= samples[5];
        end
    end
    assign data_out = output_data_reg >>> 7;

endmodule
