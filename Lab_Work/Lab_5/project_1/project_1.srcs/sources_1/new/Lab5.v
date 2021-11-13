`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/01 13:58:08
// Design Name: 
// Module Name: Lab5
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


module divider1 (clk_out,clk_in);
input clk_in;
output clk_out;
reg clk_out;
reg [25:0] cnt;

always @ (posedge clk_in)
begin
if(cnt == 26'b10111110101111000001111111)
begin
clk_out<=~clk_out;
cnt<=26'b0;
end
else cnt<=cnt+1'b1;
end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module divider2 (clk_out,clk_in);
input clk_in;
output clk_out;
reg clk_out;
reg [14:0] cnt;
always @ (posedge clk_in)
begin
if(cnt == 15'b110000110100111)
begin
clk_out<=~clk_out;
cnt<=15'b0;
end
else cnt<=cnt+1'b1;
end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module one (onedis, clk, reset);
input clk, reset;
output [6:0] onedis;
reg [6:0] onedis;
reg [3:0] temp;

always @ (posedge clk) 
begin
if (reset == 1) temp <= 4'b0000;
else
begin
if (temp == 4'b1001) temp <= 4'b0000;
else temp = temp+1'b1;
end
end

always @ (temp)
begin
case (temp)
4'b0000: onedis = 7'b0000001;
4'b0001: onedis = 7'b1001111;
4'b0010: onedis = 7'b0010010;
4'b0011: onedis = 7'b0000110;
4'b0100: onedis = 7'b1001100;
4'b0101: onedis = 7'b0100100;
4'b0110: onedis = 7'b0100000;
4'b0111: onedis = 7'b0001111;
4'b1000: onedis = 7'b0000000;
4'b1001: onedis = 7'b0000100;
endcase
end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ten (tendis, clk, reset);
input clk, reset;
output [6:0] tendis;
reg [6:0] tendis;
reg [3:0] temp1;
reg [2:0] temp2;

always @ (posedge clk)
begin
if (reset ==1)
begin
temp1 <= 4'b0000;
temp2 <= 3'b000;
end
else
begin
if (temp1 == 4'b1001)
begin
if (temp2 == 3'b101) begin
temp1 <= 4'b0000;
temp2 <= 3'b000;
end
else begin
temp1 <= 4'b0000;
temp2 <= temp2+1'b1;
end
end
else begin
temp1 <= temp1+1'b1;
end
end
end

always @ (temp2)
begin
case (temp2)
3'b000: tendis = 7'b0000001;
3'b001: tendis = 7'b1001111;
3'b010: tendis = 7'b0010010;
3'b011: tendis = 7'b0000110;
3'b100: tendis = 7'b1001100;
3'b101: tendis = 7'b0100100;
endcase
end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Lab5(dis, control, clk, reset);
input clk, reset;
output [6:0] dis;
output [3:0] control;
reg [6:0] dis;
reg [3:0] control;
wire clk1;
wire clk2;
wire [6:0] onedis1;
wire [6:0] tendis1;
initial begin
control <= 4'b1110;
end
divider1 cl1 (clk1, clk);
divider2 cl2 (clk2, clk);
one one1 (onedis1, clk1, reset);
ten ten1 (tendis1, clk1, reset);
always @ (posedge clk2)
begin 
if (control == 4'b1110) control <= 4'b1101;
else if (control == 4'b1101) control <= 4'b1011;
else if (control == 4'b1011) control <= 4'b0111;
else if (control == 4'b0111) control <= 4'b1110;
end
always @ (control)
begin
case (control)
4'b1110: dis <= onedis1;
4'b1101: dis <= tendis1;
4'b1011: dis <= 7'b1111111;
4'b0111: dis <= 7'b1111111;
endcase
end
endmodule
