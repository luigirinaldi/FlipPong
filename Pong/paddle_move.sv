module paddle_move #(
    parameter HEIGHT = 16,
    parameter PADDLE_HEIGHT = 5
)
(
    input en,
    input clk,
    input rst,
    input [1:0] controls,
    input [HEIGHT-1:0] paddle_y,
    output [HEIGHT-1:0] paddle_y_new
);

    localparam PADDLE_TOP_MIDDLE = (PADDLE_HEIGHT-1)/2;

always_comb begin
    paddle_y_next = paddle_y;
    if(paddle_y + PADDLE_TOP_MIDDLE + controls[1] < HEIGHT)
        paddle_y_next = paddle_y + controls[1];
    if(paddle_y - PADDLE_TOP_MIDDLE - controls[0] >= 0)
        paddle_y_next = paddle_y - controls[0];
end

always_ff @(posedge clk) begin
    if (rst == 1)
        paddle_y_new <= HEIGHT/2;
    else if (en == 1)
        paddle_y_new <= paddle_y_next;
    else
        paddle_y_new <= paddle_y;
end

endmodule