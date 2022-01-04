// ------------------------------------------------------------------------- --
// Title         : Clockwork
// Project       : Praktikum FPGA-Entwurfstechnik
// ------------------------------------------------------------------------- --
// File          : timeAndDateClock.v
// Author        : Shutao Zhang
// Company       : IDS RWTH Aachen 
// Created       : 2018/08/16
// ------------------------------------------------------------------------- --
// Description   : Clockwork for a DCF77 radio-controlled clock
// ------------------------------------------------------------------------- --
// Revisions     :
// Date        Version  Author  Description
// 2018/08/16  1.0      SH      Created
// 2018/09/20  1.1      TS      Clean up, comments
// ------------------------------------------------------------------------- --

module timeAndDateClock(input clk,                // global 10Mhz clock
                        input clkEn1Hz,           // 1Hz clock
                        input nReset,             // asynchronous reset (active low)  
                        input setTimeAndDate_in,  
                        input[43:0] timeAndDate_In,     
                        output reg[43:0] timeAndDate_Out
								);   

// ---------- YOUR CODE HERE ---------- 

initial
begin
timeAndDate_Out <= 44'b00001000000000000000000000000000000000000000;

end

always@ (posedge clk ) begin
	if (!setTimeAndDate_in) timeAndDate_Out <= timeAndDate_In;
  else if (!nReset) timeAndDate_Out <= 44'b00001000000000000000000000000000000000000000;
  else if(clkEn1Hz) begin 
		if (timeAndDate_Out[3:0] < 9) timeAndDate_Out[3:0] <= timeAndDate_Out[3:0]+1;
        else begin //time
             timeAndDate_Out[3:0] <= 0;
             if (timeAndDate_Out[6:4] < 5) timeAndDate_Out[6:4] <= timeAndDate_Out[6:4]+1;
             else begin
               timeAndDate_Out[6:4] <= 0;
               
               if (timeAndDate_Out[10:7] < 9) timeAndDate_Out[10:7] <= timeAndDate_Out[10:7]+1;
               else begin
                 timeAndDate_Out[10:7] <= 0;
                 if (timeAndDate_Out[13:11] < 5) timeAndDate_Out[13:11] <= timeAndDate_Out[13:11]+4'b1;
                 else begin
                   timeAndDate_Out[13:11] <= 0;
                   
                   if (timeAndDate_Out[19:18] < 2 && timeAndDate_Out[17:14] < 9 || timeAndDate_Out[19:18] == 2 && timeAndDate_Out[17:14] < 3) timeAndDate_Out[17:14] <= timeAndDate_Out[17:14]+1;
                   else begin
                     timeAndDate_Out[17:14] <= 0;
                     if (timeAndDate_Out[19:18] < 2) timeAndDate_Out[19:18] <= timeAndDate_Out[19:18]+1;
                     else begin
                       timeAndDate_Out[19:18] <= 0;
             //date
             if (timeAndDate_Out[41:39] < 7) timeAndDate_Out[41:39] <= timeAndDate_Out[41:39]+1;
             else timeAndDate_Out[41:39] <= 3'b001;
				 
             if (timeAndDate_Out[25:24] < 3 && timeAndDate_Out[23:20] < 9 || timeAndDate_Out[25:24] == 3 && timeAndDate_Out[23:20] < 1) timeAndDate_Out[23:20] <= timeAndDate_Out[23:20]+1;
                 else begin
                    if (timeAndDate_Out[25:24] == 3 )timeAndDate_Out[23:20] <= 1;
						  else timeAndDate_Out[23:20] <= 0;
                   if (timeAndDate_Out[25:24] < 3) timeAndDate_Out[25:24] <= timeAndDate_Out[25:24]+1;
                   else begin
                     timeAndDate_Out[25:24] <= 0;
					
                     
                     if (timeAndDate_Out[30] ==0 && timeAndDate_Out[29:26] < 9 || timeAndDate_Out[30] == 1 && timeAndDate_Out[29:26] < 2) timeAndDate_Out[29:26] <= timeAndDate_Out[29:26]+1;
                     else begin begin
                                if(timeAndDate_Out[30] == 1)timeAndDate_Out[29:26] <= 1;
                                else timeAndDate_Out[29:26] <= 0;
                                end
                       if (timeAndDate_Out[30] < 1) timeAndDate_Out[30] <= timeAndDate_Out[30]+1;
                       else begin
                       timeAndDate_Out[30] <= 0;
				
                 
                     if (timeAndDate_Out[34:31] < 9) timeAndDate_Out[34:31] <= timeAndDate_Out[34:31]+1;
                     else begin
                       timeAndDate_Out[34:31] <= 0;
                       if (timeAndDate_Out[38:35] < 9) timeAndDate_Out[38:35] <= timeAndDate_Out[38:35]+1;
                       else begin
                         timeAndDate_Out[38:35] <= 0;
								
                       end
                     end
                   end
                 end
               end
             end   
                       
                     end
                   end
                 end
               end
             end
        end
      end
else timeAndDate_Out <= timeAndDate_Out;
end



endmodule
