module pong #(
    parameter WIDTH = 32,
    parameter HEIGHT = 32,
    parameter BALL_SPEED = 1.414,
    parameter PADDLE_HEIGHT = 5
)
(
    input logic clk,
    input logic rst,
    input logic en,
    input logic [1:0] controls1,
    input logic [1:0] controls2,
    output logic [WIDTH-1:0][HEIGHT-1:0] screen,
    output logic [3:0] score1,
    output logic [3:0] score2
);

    logic [WIDTH-1:0][HEIGHT-1:0] screen_next;
    logic [WIDTH-1:0] paddle1_x = 1;
    logic [HEIGHT-1:0] paddle1_y = HEIGHT/2;
    logic [WIDTH-1:0] paddle2_x = WIDTH-1;
    logic [HEIGHT-1:0] paddle2_y = HEIGHT/2;

    logic [3:0] score1 = 0;
    logic [3:0] score2 = 0;

    paddle_move #(HEIGHT,PADDLE_HEIGHT) paddle1 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .controls(controls1),
        .paddle_y(paddle1_y),
        .paddle_y_new(paddle1_y)
    );

    paddle_move #(HEIGHT,PADDLE_HEIGHT) paddle2 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .controls(controls2),
        .paddle_y(paddle2_y),
        .paddle_y_new(paddle2_y)
    );

    always_ff @(posedge clk) begin
        
    end

endmodule