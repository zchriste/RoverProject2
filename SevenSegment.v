`timescale 1ns / 1ps


module SevenSegment(
    input clk,
    input SensorA, SensorB,
    input [3:0] Direction,
    output [6:0] seg,
    output [3:0] an
    );

    wire [6:0] Dig0Seg, Dig1Seg, Dig2Seg, Dig3Seg;
    reg [18:0] count;
    initial count = 0;

    always @ (posedge clk)
        count = count + 1;

    assign Dig0Seg = (Direction == 4'b1001) ? 7'b0000011 :
                     (Direction == 4'b0110) ? 7'b0001110 : 7'b1111111;
                     
    assign {Dig3Seg,Dig2Seg,Dig1Seg} = (SensorA || SensorB) ? {7'b0010001, 7'b0000110, 7'b0010010}:
                                                              {7'b0101011, 7'b0100011, 7'b1111111};    

   // assign (duty_from_sw) = (SensorA || SensorB) ? sw[5:4] == 2'b00) ? 12'd0;     //stop when over 1A                                                     
                                           //  {7'b0101011, 7'b0100011, 7'b1111111};
                                           //  {7'b0010001, 7'b0000110, 7'b0010010} :

    assign {seg,an} = (count[18:17] == 2'b00) ? {Dig0Seg, 4'b1110} :
                      (count[18:17] == 2'b01) ? {Dig1Seg, 4'b1101} :
                      (count[18:17] == 2'b10) ? {Dig2Seg, 4'b1011} :
                      (count[18:17] == 2'b11) ? {Dig3Seg, 4'b0111} : {7'b1111111,4'b1110};
endmodule


