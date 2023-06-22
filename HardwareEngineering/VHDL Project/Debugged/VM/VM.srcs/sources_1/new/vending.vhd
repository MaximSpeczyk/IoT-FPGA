----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2023 04:17:05 PM
-- Design Name: 
-- Module Name: vending - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity VM is

port (

 clk, reset: in std_logic;
 coin_in, pickItem: in std_logic_vector(3 downto 0);
selectedItem, dispense: out std_logic_vector(3 downto 0);
refundOutLed, idle_state, selected_state, review_state, output_state: out std_logic
    

);

end entity;

architecture VMarch of VM is

signal total, refund, price, product : integer := 0;
type state is( idle, selected, review, output);
signal current_state, next_state : state;
signal greaterEqual : std_logic := '0';

begin

memory: process (clk, reset)
begin
 
	if (reset ='0') then   --- reser ='1' not resetting 
		current_state <= idle;
	elsif (rising_edge(clk)) then
		current_state <= next_state;
	end if;

end process;

logic: process (coin_in, pickItem, current_state)
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

end architecture;