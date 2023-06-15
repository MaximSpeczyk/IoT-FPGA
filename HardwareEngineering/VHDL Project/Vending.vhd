
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vending is
  port (
    CLK100MHZ, reset: in std_logic;
	pickItem: in std_logic_vector(2 downto 0);
	selectedItem: out std_logic_vector(2 downto 0);
	coin_in: in std_logic_vector(3 downto 0);
    dispense: out std_logic_vector(6 downto 0));
end Vending;

architecture VendingData of Vending is
component DECODERBIT is
	port(BCD: in std_logic_vector(3 downto 0);
	    segment: out std_logic_vector(6 downto 0));
end component;


  type state is (idle, select_item, review, output);
  signal current_state, next_state: state;

begin
    --replaced every CLK with CLK100MHZ
  -- set memory state
  process(CLK100MHZ, reset)
    variable temp: integer;
  begin
    if (reset = '1') then
      current_state <= idle;
    elsif (CLK100MHZ 'event and CLK100MHZ = '1') then
      current_state <= next_state; -- Assign current_state based on next_state
    end if;
  end process;

  -- deciding the next state
  process(current_state, pickItem(0), pickItem(1), pickItem(2), coin_in(0), coin_in(1), coin_in(2), coin_in(3))
	variable total, price, product, refund: integer;
  begin
    case (current_state) is
      when idle =>
	selectedItem <= "000";
	dispense <= "0000000";
     	if (pickItem(0) = '1') then
		price := 7;
		product := 1;
		total := 0;
		next_state <= select_item;
	end if;
	if (pickItem(1) = '1') then
		price := 9;
		product := 2;
		total := 0;
		next_state <= select_item;
	end if;
     	if (pickItem(2) = '1') then
		price := 2;
		product := 3;
		total := 0;
		next_state <= select_item;
	end if;

	when select_item =>
	if (coin_in(0) = '1') then
		total := total + 1;
	elsif (coin_in(1) = '1') then
		total := total + 2;
	elsif (coin_in(2) = '1') then
		total := total + 4;
	elsif (coin_in(3) = '1') then
		total := total + 8;
	end if;
	if (price > total) then
		next_state <= select_item;
	elsif (price <= total) then
		refund := total - price;
		next_state <= review;
	end if;

	when review => 
		if (refund >= 4) then
		selectedItem <= "100";
		refund := refund - 4;
		elsif (refund >= 2) then
		selectedItem <= "010";
		refund := refund - 2;
		elsif (refund >= 1) then
		selectedItem <= "001";
		refund := refund - 1;
		end if;
		if (refund > 0) then
		next_state <= review;
		elsif (refund = 0) then
		next_state <= output;
		end if;

	when output =>
		if (product = 1) then
		dispense <= "0000001";
		elsif (product = 2) then
		dispense <= "0000010";
		elsif (product = 3) then
		dispense <= "0000100";
		end if;
		--C <= dispense; 
		next_state <= idle;

	---when others => next_state <= idle;
	end case;
  end process;
DISPLAY: DECODERBIT port map(coin_in, dispense);
end VendingData;
