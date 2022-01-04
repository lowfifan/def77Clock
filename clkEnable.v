// created 17.07.2018 by Cecilia Hoeffler
// template for experiment 2
//you should be able to reduce the frequency of the clock with this module


module clkEnable(
			input clock_5,
			input reset,
			output enable_out
			);
							
			parameter freq_divider = 10000; 
			reg enable;
			reg [20:0] counter;
			assign enable_out = enable;
			always@ (posedge clock_5 or negedge reset) begin
			  if (!reset) counter <= 0;
			   else if (counter < freq_divider) counter <= counter+1;
			   else counter <= 0;
			end
			
			always@ (posedge clock_5 or negedge reset) begin
			  if (!reset) enable <= 0;
			  else if (counter == freq_divider - 1) enable <= 1;
			  else enable <= 0;
			end
			 
			
						
endmodule