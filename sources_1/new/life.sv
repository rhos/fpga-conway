`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2017 09:39:13 AM
// Design Name: 
// Module Name: life
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


 module life(input logic clk,
             input logic reset,
             input logic [9:0][9:0] init,
             output logic [9:0][9:0] out);

    logic [9:0][9:0] state;
    logic [9:0][9:0] nextstate;
    
    always_ff @(posedge clk, posedge reset) 
        if(reset) state <= init;
        else state <= nextstate;
    
    generate
        genvar i,j;
        for (i = 0; i <= 9; i = i + 1) begin
            for (j = 0; j <= 9; j = j + 1) begin
                logic [3:0] sum;
                neighsum n(i,j, state, sum);
                calc c(sum, state[i][j],nextstate[i][j]);
            end
        end
    endgenerate
    
    assign out = nextstate;
 endmodule
 
module neighsum(input logic[3:0] i,j,
                input logic [9:0][9:0] state,
                output logic [3:0] sum);
    logic [3:0] l,r,u,d;
    assign l = i == 4'd0 ? 4'd9 : i - 1;
    assign r = i == 4'd9 ? 4'd0 : i + 1;
    assign u = j == 4'd0 ? 4'd9 : j - 1;
    assign d = j == 4'd9 ? 4'd0 : j + 1;
    assign sum = state[l][d] + 
                 state[l][j] + 
                 state[l][u] + 
                 state[i][d] + 
                 state[i][u] + 
                 state[r][d] + 
                 state[r][j] + 
                 state[r][u];    
endmodule

module calc(input logic [3:0] sum,
             input logic state,
             output logic nextstate);
    assign nextstate = ((sum == 2 & state) | sum == 3) ? 1:0;             
endmodule

module copy(input logic in,
            output logic out);
    assign out = in;
endmodule