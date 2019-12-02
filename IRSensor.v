`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2019 12:44:13 AM
// Design Name: 
// Module Name: IRSensor
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

module IRSensor(
    input             clk,
    input [1:0]       MMvalues,
    input             EnableIRModule,
    input             ResetIRModule,
    input             ActivePeriodFinished,
    output reg [1:0]  ServoNum, // Which servo should be moving?
    output reg [20:0] ActiveServoDuty,
    output reg        IRModuleDone // Finished moving all the servos to check the moisture, etc
    );

   localparam LEFT=80_000, MIDDLE=150_000, RIGHT=240_000;
   localparam MOVE_ARM = 0, WAIT = 1, RESET_ARM = 2, WAIT_FROM_RESET = 3;      

   reg [6:0]   counter;
   reg [1:0]   state; 
   reg         flag;
   reg [1:0]   MMvalues_sync;

   wire [1:0]  which_servo;

   assign which_servo = (MMvalues_sync == 2'b00) ? 1 :  //assiging moisture outputs to a specific servo
                        (MMvalues_sync == 2'b01) ? 2 :
                        (MMvalues_sync == 2'b11) ? 3 : 0;

   initial 
     {counter, state, flag, 
      IRModuleDone, ActiveServoDuty, 
      ServoNum, MMvalues_sync} = 0;

   always @(posedge clk)
     begin
        if (ResetIRModule)
          begin
             /*AUTORESET*/
             // Beginning of autoreset for uninitialized flops
             ActiveServoDuty <= 21'h0;
             IRModuleDone <= 1'h0;
             MMvalues_sync <= 2'h0;
             ServoNum <= 2'h0;
             counter <= 7'h0;
             flag <= 1'h0;
             state <= 2'h0;
             // End of automatics
          end  
        else if (EnableIRModule && ~IRModuleDone) 
          case (state) // If it's not counting
            MOVE_ARM:
              begin
                 ServoNum <=flag ? which_servo:0;    
                 ActiveServoDuty <= LEFT;
                 state <= WAIT;
              end

            WAIT:
              begin
                 if (ActivePeriodFinished)
                   if (counter < 120) 
                     counter <= counter + 1;
                   else
                     begin
                        counter <= 0;
                        MMvalues_sync <= MMvalues;
                        // Move the state back to initial state if we're done
                        // Otherwise, move the arm back up
                        state<=RESET_ARM;
                        IRModuleDone<=flag ? 1:0;
                     end
              end
            
            RESET_ARM:
              begin
                 ServoNum <= 0;    
                 ActiveServoDuty <= RIGHT;
                 flag<=1;
                 state <= WAIT_FROM_RESET;
              end

            WAIT_FROM_RESET:
              begin
                 if (ActivePeriodFinished)
                   if (counter < 120) 
                     counter <= counter + 1;
                   else
                     begin
                        counter <= 0;
                        // Move the state back to initial state if we're done
                        // Otherwise, move the arm back up
                        state<=MOVE_ARM;
                        IRModuleDone<=0;
                     end
              end
          endcase
     end
endmodule
