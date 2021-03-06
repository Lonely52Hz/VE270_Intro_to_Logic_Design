`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/18 15:10:09
// Design Name: 
// Module Name: 1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module new_keypad (clk,reset,row,col,ssd);
    input clk,reset;
    input [3:0] row;
    output reg [3:0] col;
    output reg [6:0] ssd;
    reg load;
    reg clk_1;
    reg [15:0] count;
    reg [3:0] code,binary;
    reg [3:0] curr,next;
    wire orrow;
    
    always @(posedge clk)
        if (reset) begin clk_1<=0; count<=0; end
        else begin
            if(count>=5000) begin clk_1<=~clk_1;count<=0;end
            else count<=count+1;
        end
        
    assign orrow = row[3] || row[2] || row[1] || row[0];
    
parameter s0=4'b0000;
parameter s1=4'b0001;
parameter s2=4'b0010;
parameter s3=4'b0011;
parameter s4=4'b0100;
parameter s5=4'b0101;
parameter s6=4'b0110;
parameter s7=4'b0111;
parameter s8=4'b1000;
parameter s9=4'b1001;
    
    always @ (posedge clk_1)
        if (reset) begin curr <= 0; col <= 4'b1111; end
        else begin 
            case (curr)
                s0: begin col <= 4'b1111;
                   if (orrow == 1)  begin curr <= s1; end
                   else if (orrow == 0) curr <= s0; 
                   else curr <= s0;   
                   end
                s1: begin col <= 4'b0001;
                   if (orrow == 1)  curr <= s5; 
                   else if (orrow == 0) begin curr <= s2; col <= 4'b0010; end
                   else curr <= s0; 
                   end
                s2: begin 
                   if (orrow == 1)  curr <= s6; 
                   else if (orrow == 0) begin curr <= s3; col <= 4'b0100; end
                   else curr <= s0; 
                   end
                s3: begin 
                   if (orrow == 1)  curr <= s7; 
                   else if (orrow == 0) begin curr <= s4; col <= 4'b1000; end
                   else curr <= s0; 
                   end
                s4: begin 
                   if (orrow == 1)  curr <= s8; 
                   else if (orrow == 0) curr <= s0; 
                   else curr <= s0; 
                   end
                s5: begin col = 4'b0001;
                   case(row) 
                    4'b0001: code <= 4'b0000;
                    4'b0010: code <= 4'b0100;
                    4'b0100: code <= 4'b1000;
                    4'b1000: code <= 4'b1100;
                   endcase 
                   load = 1;
                   curr = s9;
                   end
                s6: begin col = 4'b0010;
                   case(row) 
                    4'b0001: code <= 4'b0001;
                    4'b0010: code <= 4'b0101;
                    4'b0100: code <= 4'b1001;
                    4'b1000: code <= 4'b1101;
                   endcase  
                   load = 1;
                   curr = s9;
                   end
                s7: begin col = 4'b0100;
                   case(row) 
                    4'b0001: code <= 4'b0010;
                    4'b0010: code <= 4'b0110;
                    4'b0100: code <= 4'b1010;
                    4'b1000: code <= 4'b1110;
                   endcase                    
                   load = 1; 
                   curr = s9;
                   end
                s8: begin col = 4'b1000;
                   case(row) 
                    4'b0001: code <= 4'b0011;
                    4'b0010: code <= 4'b0111;
                    4'b0100: code <= 4'b1011;
                    4'b1000: code <= 4'b1111;
                   endcase                 
                   load = 1; 
                   curr = s9;
                   end
                s9: begin col = 4'b1111;
                   load = 0; 
                   if (orrow == 1)  curr <= s9; 
                   else if (orrow == 0) curr <= s0; 
                   else curr <= s0; 
                   end
                default: begin col <= 4'b1111; curr <= 0; end
            endcase
        end
    
    always @ (posedge clk_1) begin
        if (load) begin 
            binary = code;
            case (binary)
                0:ssd = 7'b0000001;
                1:ssd = 7'b1001111;
                2:ssd = 7'b0010010;
                3:ssd = 7'b0000110;
                4:ssd = 7'b1001100;
                5:ssd = 7'b0100100;
                6:ssd = 7'b0100000;
                7:ssd = 7'b0001111;
                8:ssd = 7'b0000000;
                9:ssd = 7'b0000100;
                10:ssd = 7'b0001000;
                11:ssd = 7'b1100000;
                12:ssd = 7'b0110001;
                13:ssd = 7'b1000010;
                14:ssd = 7'b0110000;
                15:ssd = 7'b0111000;
                default: ssd = 7'b0000001;
            endcase
        end
    end
    
endmodule

