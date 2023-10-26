module conway(
    input   logic           rst,
    input   logic           clk,
    input   logic           load,
    input   logic  [255:0]  data,
    output  logic  [255:0]  q 
); 

    logic [255:0] state, next_state;
    
    assign q = state;
    
    logic [15:0] counter;
    
    integer i;
    
    always_ff @(posedge clk) begin 
        if(load)
            state <= data;
        else
            state <= next_state;
    end
    
    integer row, col;
    
    logic [2:0] accum;
    
    logic [3:0] top_index, bottom_index, left_index, right_index;
    

    /* verilator lint_off WIDTH */
    always_comb begin
        for (row = 0; row < 16; row = row + 1) begin
            top_index = row + 1'b1; 
            bottom_index = row - 1'b1;
            for (col = 0; col < 16; col = col + 1) begin
                left_index = col + 1'b1;
                right_index = col - 1'b1;
                accum = 3'b0;               
                
                accum = state[top_index * 16 + left_index] +
                        state[top_index * 16 + right_index] +
                        state[top_index * 16 + col] +
                        state[bottom_index * 16 + left_index] +
                        state[bottom_index * 16 + right_index] +
                        state[bottom_index * 16 + col] +
                        state[row * 16 + left_index] +
                        state[row * 16 + right_index];

                case (accum)
                    3'd2: next_state[row * 16 + col] = state[row * 16 + col];
                    3'd3: next_state[row * 16 + col] = 1'b1;
                    default: next_state[row * 16 + col] = 1'b0;
                endcase
            end
        end
    end
    /* verilator lint_on WIDTH */
    
endmodule
