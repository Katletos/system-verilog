module password_checker #(parameter PASSWORD_WIDTH = 4) (
    input  logic clk, rst_n, empty,
    input  logic[7:0] code,
    input  logic[PASSWORD_WIDTH-1:0][7:0] password,
    output logic[PASSWORD_WIDTH-1:0] leds
);

typedef enum {NO, FIRST, SECOND, THIRD, FOURTH } state;
state st;

always_ff @(posedge clk, negedge rst_n)
    if (~rst_n) begin 
        st <= NO;
        leds <= {PASSWORD_WIDTH{1'b0}};
    end else begin
        if (~empty) begin 
            unique case (st)
                NO:     if (password[3] == code) begin st <= FIRST;  leds[0] <= 1; end
                FIRST:  if (password[2] == code) begin st <= SECOND; leds[1] <= 1; end
                SECOND: if (password[1] == code) begin st <= THIRD;  leds[2] <= 1; end
                THIRD:  if (password[0] == code) begin st <= FOURTH; leds[3] <= 1; end
                FOURTH: begin st <= NO;  leds <= 'b0000; end 
            endcase       
        end
    end
endmodule   