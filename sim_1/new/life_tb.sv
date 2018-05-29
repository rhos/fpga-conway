`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 09:37:35 AM
// Design Name: 
// Module Name: life_tb
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


module life_tb();
    logic clk, reset;
    logic [9:0][9:0] init;
    logic [9:0][9:0] nextstate;
    
    initial begin
        init[0] = 9'b000000000;
        init[1] = 9'b000000000;
        init[2] = 9'b000000000;
        init[3] = 9'b000000000;
        init[4] = 9'b000000000;
        init[5] = 9'b000111000;
        init[6] = 9'b000000000;
        init[7] = 9'b000000000;
        init[8] = 9'b000000000;
        init[9] = 9'b000000000;
        
        reset = 1;
        #10;
        reset = 0;
        clk = 1;
    end
    always #5 clk = ~clk;
    
    life l(clk, reset, init, nextstate);
    
    
endmodule
