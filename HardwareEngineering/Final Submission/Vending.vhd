library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VM is

port (
 clk, reset: in std_logic;
 coin_in, pickItem: in std_logic_vector(3 downto 0);
Anode, Cathode: out std_logic_vector(7 downto 0);
selectedItem, dispense: out std_logic_vector(3 downto 0);
refundOutLed, idle_state, selected_state, review_state, output_state: out std_logic
);

end entity;

architecture VMarch of VM is

signal total, refund, price, product : integer := 0;
type state is( idle, selected, review, output);
signal current_state, next_state : state;
signal clk_counter: std_logic_vector(19 downto 0);
signal counter_reset: std_logic_vector(3 downto 1);
signal Display: std_logic_vector(3 downto 0);


begin

memory: process (clk, reset)
begin
 
	if (reset ='1') then   
		current_state <= idle;
	elsif (clk 'event and clk = '1') then
		current_state <= next_state;
	end if;

end process;

logic: process (product,coin_in, pickItem, current_state, total, refund, price)
begin


	case (current_state) is

  		 when idle => if ( pickItem = "0001" ) then
			                 next_state <=  selected; 
					 product <= 1;
					 price <=4;
                    selectedItem <="0001";
			      elsif ( pickItem = "0010" ) then
			                 next_state <=  selected; 
					 product <= 2;
					 price <=3;
					 selectedItem <= "0010";
			      elsif ( pickItem = "0011" ) then
			                 next_state <=  selected; 
					 product <= 3;
					 price <=2;
					 selectedItem <= "0011";
			      else
					next_state <=  idle; 
					 product <= 0;
					 price <=0;
					 selectedItem <= "0000";
			     end if;
                idle_state <= '1';
                selected_state <= '0';
                review_state <= '0';
                output_state <= '0';
                
		 when selected => if ( coin_in = "0101" ) then
					total <= 5;
					 next_state <=  review; 
					 
					
				  elsif ( coin_in = "0100" ) then
					 total <= 4;
					 next_state <=  review; 

				  elsif ( coin_in = "0011" ) then
					 total <= 3;
					 next_state <=  review; 

				  elsif ( coin_in = "0010") then
					 total <= 2;
					 next_state <=  review; 
			          else
					total <= 0;
					next_state <=  selected;
				  end if;
				idle_state <= '1';
                selected_state <= '1';
                review_state <= '0';
                output_state <= '0';
		
		 when review => if  (total >= price) then
					 refund <= total - price;
					 refundOutLed <= '1';
					 next_state <=  output;
				else	
					refund <= 0;
					refundOutLed <= '0';
					next_state <=  selected; 
					
				  end if;
                idle_state <= '1';
                selected_state <= '1';
                review_state <= '1';
                output_state <= '0';
                
	  	when output => 
				     if (product = 1) then
					   dispense <= "0001";
				     	   next_state <=  idle;
				     elsif  (product = 2) then
					   dispense <= "0010";
				     	   next_state <=  idle;
				     elsif  (product = 3) then
					   dispense <= "0011";
				     	   next_state <=  idle;
				     else
					   next_state <=  selected;
				     end if;
                idle_state <= '1';
                selected_state <= '1';
                review_state <= '1';
                output_state <= '1';
		when others => 
		          next_state <=  idle; 
					 product <= 0;
					 price <=0;
					 refund <= 0;
					 refundOutLed <= '0';
				     
				     idle_state <= '0';
                    selected_state <= '0';
                    review_state <= '0';
                    output_state <= '0';
		end case;
end process;

	----------------------------------------------------------		     
--Display  
 reset_counter: process(clk, reset)
begin
	if (reset = '1') then
		clk_counter <= (others => '0');
	elsif (clk 'event and clk = '1') then
		clk_counter <= clk_counter + 1;
	end if;
end process;

-- Activating the anode at the reset counts of the clk_counter 
--and displaying the values to be decoded by the cathode signal
counter_reset <= clk_counter(19 downto 17);
Activate_Anode: process(counter_reset, refund)
begin
	case (counter_reset) is 
		when "000" =>
			Anode <= "01111111";
		if (pickItem = "0001" ) then
		    Display <= "0100";
		elsif (pickItem = "0010" ) then
		    Display <= "0011";
		elsif (pickItem = "0100" ) then
		    Display <= "0010";
		else
		    Display <= "0000";
		end if;
		
		when "001" =>
			Anode <= "11011111";
		if (coin_in = "0101" ) then
		    Display <= "0101";
		elsif (coin_in = "0100"  ) then
		   Display <= "0100";
		elsif (coin_in = "0100" ) then
		    Display <= "0011";
		elsif (coin_in = "0010" ) then
		   Display <= "0010";
		else
		    Display <= "0000";
		end if;
		
		when"010" =>
			Anode <= "11111011";
		if (total >= price ) then
			Display <= std_logic_vector(to_unsigned(refund, display'length)); 
		else
			Display <= "0000";
		end if;
		
		when "100" =>
				Anode <= "11110111";
		if (product = 1) then
			Display <= "0001";
		elsif (product = 2) then
			Display <= "0010";
		elsif (product = 3) then
			Display <= "0100";
		else
			Display <= "0000";
		end if;
		
		when "101" =>
			Anode <= "11111101";
		  if (pickItem /= "0000")then
			Display <= "1011";
		elsif (coin_in /= "0000") then
			Display <= "1010";
		elsif (refund >= 0) then
			Display <= "1000";
		else
			Display <= "0110";
		end if;
		when others =>
			Anode <= "11111110";
			Display <= "0000";
	end case;	              	
end process;

-- passing the signal value to the cathode
Activate_Cathode: process (Display)
	begin
    	case Display is
    		when "0000" => Cathode <= "11000000"; -- "0"     
    		when "0001" => Cathode <= "11111001"; -- "1" 
    		when "0010" => Cathode <= "10100100"; -- "2" 
    		when "0011" => Cathode <= "10110000"; -- "3" 
    		when "0100" => Cathode <= "10011001"; -- "4" 
    		when "0101" => Cathode <= "10010010"; -- "5"  
    		when "0110" => Cathode <= "11100111"; -- "I" 
    		when "1011" => Cathode <= "11110011"; -- "S"  CAN CHANGE IT
    		when "1010" => Cathode <= "10011101"; -- "R"     
    		when "1000" => Cathode <= "11111100"; -- "B"  CAN CHANGE IT
--    		when "1010" => Cathode <= "00000010"; -- 0.
--    		when "1011" => Cathode <= "10011110"; -- 1.
--    		when "1100" => Cathode <= "00100100"; -- 2.
--    		when "1101" => Cathode <= "01100011"; -- C
--    		when "1110" => Cathode <= "01100001"; -- E
    		when others => Cathode <= "01110001"; -- F
    	end case;
end process;


end architecture;
