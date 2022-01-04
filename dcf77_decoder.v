// ------------------------------------------------------------------------- --
// Title         : DCF77-Decoder
// Project       : Praktikum FPGA-Entwurfstechnik
// ------------------------------------------------------------------------- --
// File          : timeAndDateClock.v
// Author        : Tim Stadtmann
// Company       : IDS RWTH Aachen 
// Created       : 2018/09/20
// ------------------------------------------------------------------------- --
// Description   : Decodes the dcf77 signal
// ------------------------------------------------------------------------- --
// Revisions     :
// Date        Version  Author  Description
// 2018/09/20  1.0      TS      Created
// ------------------------------------------------------------------------- --

module dcf77_decoder(clk,             // Global 10MHz clock 
                     clk_en_1hz,      // Indicates start of second
                     nReset,          // Global reset
                     minute_start_in, // New minute trigger
                     dcf_Signal_in,   // DFC Signal
                     timeAndDate_out,
                     parityCheck,
                     parityMinutes,
                     parityHours,
                     zeroedCounter,
                     parityDates,
                     data_valid,      // Control signal, High if data is valid
                     dcf_value);      // Decoded value of dcf input signal
                     
input clk, 
      clk_en_1hz,     
      nReset,  
      minute_start_in,
      dcf_Signal_in;  
      
output reg[43:0]  timeAndDate_out= 44'b0;
reg[43:0] timeAndDate_outemp = 44'b0;
output reg        data_valid;
output            dcf_value;
   
// ---------- YOUR CODE HERE ---------- 
output reg[10:0] zeroedCounter;
reg clk1hzPast;
output reg  parityMinutes;
output reg  parityHours;
output reg  parityDates;
reg[10:0] validcounter;
wire dcf_value = dcf_Signal_in;
wire posedgeClk1hz = clk_en_1hz == 1 && clk1hzPast == 0;
output wire parityCheck;
assign parityCheck = !parityMinutes && !parityHours && !parityDates;
wire[10:0] minStore = zeroedCounter -14;
wire[10:0] hourStore = zeroedCounter -15;
wire[10:0] dayStore = zeroedCounter -16;
wire[10:0] monthYearStore = zeroedCounter -19;
wire[10:0] weekdayStore = zeroedCounter -3;
wire[10:0] timezoneStore = zeroedCounter +25;
wire[3:0] lowSecond = zeroedCounter % 10;
wire[2:0] hignSecond = zeroedCounter / 10;

always@(posedge clk) begin
  if (!nReset) timeAndDate_outemp <=  44'b0;
  else if (!posedgeClk1hz) timeAndDate_outemp <= timeAndDate_outemp;
  else begin timeAndDate_outemp[3:0] <= lowSecond;
             timeAndDate_outemp[6:4] <= hignSecond;
  if (zeroedCounter >= 10'd21 && zeroedCounter <= 10'd27) timeAndDate_outemp[minStore] <= !dcf_Signal_in;
  else if (zeroedCounter >= 10'd29 && zeroedCounter <= 10'd34) timeAndDate_outemp[hourStore] <= !dcf_Signal_in;
  else if (zeroedCounter >= 10'd36 && zeroedCounter <= 10'd41) timeAndDate_outemp[dayStore] <= !dcf_Signal_in;
  else if (zeroedCounter >= 10'd45 && zeroedCounter <= 10'd57) timeAndDate_outemp[monthYearStore] <= !dcf_Signal_in;
  else if (zeroedCounter >= 10'd42 && zeroedCounter <= 10'd44) timeAndDate_outemp[weekdayStore] <= !dcf_Signal_in;
  else if (zeroedCounter >= 10'd17 && zeroedCounter <= 10'd18) timeAndDate_outemp[timezoneStore] <= !dcf_Signal_in;
  else  timeAndDate_outemp <= timeAndDate_outemp;
  end
end

always@(posedge clk) begin
  if (!nReset) clk1hzPast <=  0;
  else clk1hzPast <=  clk_en_1hz;
end

always@(posedge clk) begin
  if(!nReset) zeroedCounter <= 0;
  else if (minute_start_in) zeroedCounter <= 0;
  else if (posedgeClk1hz) zeroedCounter <= zeroedCounter+1;
  else zeroedCounter <= zeroedCounter;
end

always@(posedge clk) begin
  if (!nReset) parityMinutes <= 0;
  else if (zeroedCounter == 0) parityMinutes <= 0;
  else if (zeroedCounter >= 10'd21 && zeroedCounter <= 10'd28 && posedgeClk1hz) parityMinutes <= parityMinutes + !dcf_Signal_in;
  else parityMinutes <= parityMinutes;
end

always@(posedge clk) begin
  if (!nReset) parityHours <= 0;
  else if (zeroedCounter == 0) parityHours <= 0;
  else if (zeroedCounter >= 10'd29 && zeroedCounter <= 10'd35 && posedgeClk1hz) parityHours <= parityHours + !dcf_Signal_in;
  else parityHours <= parityHours;
end

always@(posedge clk) begin
  if (!nReset) parityDates <= 0;
  else if (zeroedCounter == 0) parityDates <= 0;
  else if (zeroedCounter >= 10'd36 && zeroedCounter <= 10'd58 && posedgeClk1hz) parityDates <= parityDates + !dcf_Signal_in;
  else parityDates <= parityDates;
end

always@ (posedge clk) begin
  if (!nReset) validcounter <= 0;
  else if(zeroedCounter == 59 && posedgeClk1hz && parityCheck) validcounter <= 59;
  else if (validcounter > 0 && posedgeClk1hz) validcounter <= validcounter -1;
  else validcounter <= validcounter;

end

always@ (posedge clk) begin
  if (!nReset) data_valid <= 0;
  else if (zeroedCounter == 59 && posedgeClk1hz && parityCheck) data_valid <= 1;
  else if (validcounter == 0) data_valid <= 0;
  else data_valid <= data_valid;
end

always@(posedge clk) begin
  if (!nReset)timeAndDate_out <= 44'b0;
  else begin
    timeAndDate_out[3:0] <= lowSecond;
    timeAndDate_out[6:4] <= hignSecond;
    if(data_valid) timeAndDate_out[43:7] <= timeAndDate_outemp[43:7];
  else timeAndDate_out[43:7] <= timeAndDate_out[43:7];
  end
end
endmodule              
              

