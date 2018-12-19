`timescale 1ns / 1ps


module vga(input logic clk,
            input logic [15:0] sw,
            input logic btnCpuReset, btnC, btnU, btnD, btnL, btnR,
            output logic hsync, vsync,
            output logic [3:0] red, green, blue);
	
    parameter hbp = 144;
    parameter hfp = 784;
    parameter vbp = 31;
    parameter vfp = 511;
    
    logic [9:0] hc, vc, x, y;
    logic vgaclk;
    
    assign x = hc - hbp;
    assign y = vc - vbp;
    
    logic btnCSync;
    sync csync(clk,btnC,btnCSync);
    logic btnDSync;
    sync dsync(clk,btnD,btnDSync);
    
    divider div(clk, vgaclk);
    vgaController vgaCont(vgaclk, hsync, vsync, hc, vc);
    videoGen videoGen(btnDSync, btnCSync, sw, x, y, red, green, blue);
endmodule

module videoGen(input logic clk,
                input logic button,
                input logic [15:0] sw,
                input logic [9:0] x,y,
                output logic [3:0] r,g,b);
    logic [9:0][9:0] init;
    logic [9:0][9:0] nextstate;
    
    life l(clk, button, init, nextstate);
        
    always_comb begin       
        init[0] = 9'b000000000;
        init[1] = 9'b000000000;
        init[2] = 9'b000000000;
        init[3] = 9'b000000000;
        init[4] = 9'b000010000;
        init[5] = 9'b001010000;
        init[6] = 9'b000110000;
        init[7] = 9'b000000000;
        init[8] = 9'b000000000;
        init[9] = 9'b000000000;
    end
    always_comb begin
        if (x >= 0 && 
            x < 640 && 
            y >= 0 && 
            y < 480 &&
            nextstate[x/64][y/48] == 1)
        begin
            {r,g,b} = sw[11:0];
        end else begin
            {r,g,b} = 12'd0;
        end
    end       
endmodule

module divider(input logic clk,
                output logic div);
    logic [1:0] pxclk;
    
    always_ff @ (posedge clk) begin
        pxclk <= pxclk + 1;
    end
    
    assign div = pxclk[1];    
endmodule  

module vgaController (input logic vgaclk,
					  output logic hsync, vsync, 
				      output logic [9:0] hc, vc);

    parameter hpixels = 800;
    parameter vlines = 521;
    parameter hpulse = 96;
    parameter vpulse = 2;
    parameter hbp = 144;
    parameter hfp = 784;
    parameter vbp = 31;
    parameter vfp = 511;
    always_ff @ (posedge vgaclk)
        if (hc < hpixels - 1)
            hc <= hc + 1;
        else begin
            hc <= 0;
            if (vc < vlines - 1)
                vc <= vc + 1;
            else
                vc <= 0;
        end
    
    assign hsync = (hc < hpulse) ? 0:1;
    assign vsync = (vc < vpulse) ? 0:1;
endmodule 

module sync(input logic clk,
            input logic d,
            output logic q);
    logic n1;
    always_ff @(posedge clk) begin
        n1 <= d;
        q <= n1;
    end
endmodule
