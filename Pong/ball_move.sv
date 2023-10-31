module ball_move #(
    parameter WIDTH = 8,
    parameter HEIGHT = 8,
    parameter BALL_SPEED = 1.414 
) (
    input clk,
    input rst,
    input [HEIGHT-1:0] paddle1_y,
    input [HEIGHT-1:0] paddle2_y,
    output [WIDTH-1:0] ball_x_next,
    output [HEIGHT-1:0] ball_y_next,

);
    always_comb begin

    end

endmodule