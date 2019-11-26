`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2019 12:40:48 AM
// Design Name: 
// Module Name: IPSMovement
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

module IPSMovement(
    input             clk,
    input [2:0]       IPS,
    input             IR,
    input             IRModuleDone,
    output reg [3:0]  Direction,
    output reg [11:0] DutyA, DutyB,
    output reg        EnableIRModule,
    output reg        ResetIRModule
    );

   reg [1:0]         state; // 0 means line following (with IR), 1 means line following (ignore IR until it hits 0), 2 means move servos
   localparam LINE_FOLLOW_IR = 0, LINE_FOLLOW_NO_IR = 1, MOVE_SERVOS = 2;

   initial 
     begin
        {DutyA,DutyB} <=0;
        EnableIRModule<=0;
        Direction <=0;
        state<=0;
     end        

   always @ (posedge clk)
     case (state)
       LINE_FOLLOW_IR, LINE_FOLLOW_NO_IR:
         begin
            ResetIRModule<=0;
            if (state == LINE_FOLLOW_IR && IR)
              state <= MOVE_SERVOS;

            else if (state == LINE_FOLLOW_NO_IR && !IR)
              state <= LINE_FOLLOW_IR;

            casex (IPS) 
              3'b111:     //all sensors detected, stop 
                begin
                   Direction <= 4'b0110;
                   {DutyA,DutyB} <= {12'd0, 12'd0};
                end

              3'b010 :  //middle IPS detected, go straight
                begin
                   Direction <= 4'b0110;
                   {DutyA,DutyB} <= {12'd4000, 12'd4000};
                end

              3'b1x0: //LEFt or left and middle IPS detected, pivot left
                begin
                   Direction <= 4'b0101;
                   {DutyA,DutyB} <= {12'd3000, 12'd3000};
                end
              
              3'b0x1 : //Right or Right and middle IPS detected, pivot right
                begin
                   Direction <= 4'b1010;
                   {DutyA,DutyB} <= {12'd3000, 12'd3000};    
                end

              default:
                begin
                   Direction <= 4'b1001; //Backwards direction to get back on track
                   {DutyA,DutyB} <= {12'd4000,12'd4000};
                end
            endcase
         end

       MOVE_SERVOS: // State 2 for moving servos
         begin
            Direction <= 4'b0;
            {DutyA,DutyB} <= {12'd0,12'd0};

            // Set enable of IR sensor module
            EnableIRModule <= 1;
            
            if (IRModuleDone)
              begin
                 EnableIRModule <= 0;
                 ResetIRModule <= 1;
                 state <= LINE_FOLLOW_NO_IR;
              end
         end
       
       default: state<=LINE_FOLLOW_IR;
     endcase
endmodule
