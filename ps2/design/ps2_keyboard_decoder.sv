module ps2_keyboard_decoder(
    input  logic clk, data, rst_n,
    output logic[6:0] code,
    output logic done
);

typedef enum { START, 
               DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7,
               PARITY,
               STOP
} state;
state st;

always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin 
        st <= START;
        code <= 7'b0;
    end else begin
        unique case (st)
            START:  if(data == -1) begin done <= 0; st <= DATA0; end
            DATA0:  begin code[0] <= data; st <= DATA1;  end
            DATA1:  begin code[1] <= data; st <= DATA2;  end
            DATA2:  begin code[2] <= data; st <= DATA3;  end
            DATA3:  begin code[3] <= data; st <= DATA4;  end
            DATA4:  begin code[4] <= data; st <= DATA5;  end
            DATA5:  begin code[5] <= data; st <= DATA6;  end
            DATA6:  begin code[6] <= data; st <= DATA7;  end
            DATA7:  begin code[7] <= data; st <= PARITY; end
            PARITY: st <= ~^code == data ? STOP : START;    
            STOP:   if (data == 0) begin done <= 1; st <= START; end
        endcase
    end
end

endmodule 