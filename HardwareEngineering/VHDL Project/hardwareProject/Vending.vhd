
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vending is
  port (
    clk, reset: in std_logic;
	pickItem: in std_logic_vector(3 downto 0);
	selectedItem: out std_logic_vector(3 downto 0);
	coin_in: in std_logic_vector(3 downto 0);
    --display_Amount: out std_logic_vector(3 downto 0);
    dispense: out std_logic_vector(3 downto 0));
end Vending;

architecture VendingData of Vending is
--component segmentDisplay is
--    Port ( displayA : in STD_LOGIC_VECTOR (3 downto 0);
--           displayB : in STD_LOGIC_VECTOR (3 downto 0);
--           displayC : in STD_LOGIC_VECTOR (3 downto 0);
--           displayD : in STD_LOGIC_VECTOR (3 downto 0);
--           Asegment : out STD_LOGIC;
--           Bsegment : out STD_LOGIC;
--           Csegment : out STD_LOGIC;
--           Dsegment : out STD_LOGIC;
--           Esegment : out STD_LOGIC;
--           Fsegment : out STD_LOGIC;
--           Gsegment : out STD_LOGIC;
--           select_displayA : out STD_LOGIC;
--           select_displayB : out STD_LOGIC;
--           select_displayC : out STD_LOGIC;
--           select_displayD : out STD_LOGIC;
--           clk : in STD_LOGIC);
--end component;


  type state is (idle, select_item, review, output);
  signal current_state, next_state: state;
   signal A, B, C, D: STD_LOGIC_VECTOR (3 downto 0);
begin
    --replaced every CLK with CLK100MHZ
  -- set memory state
  process(clk, reset)
    variable temp: integer;
  begin
    if (reset = '1') then
      current_state <= idle;
    elsif (clk 'event and clk = '1') then
      current_state <= next_state; -- Assign current_state based on next_state
    end if;
  end process;

  -- deciding the next state
  process(current_state, pickItem(0), pickItem(1), pickItem(2), coin_in(0), coin_in(1), coin_in(2), coin_in(3))
	variable total, price, product, refund: integer;
  begin
    case (current_state) is
      when idle =>
	selectedItem <= "0000";
	dispense <= "0000";
     	if (pickItem = "0001") then
		price := 7;
		product := 1;
		total := 0;
		next_state <= select_item;
	end if;
	if (pickItem = "0010") then
		price := 9;
		product := 2;
		total := 0;
		next_state <= select_item;
	end if;
     	if (pickItem = "0100") then
		price := 2;
		product := 3;
		total := 0;
		next_state <= select_item;
		else
		price := 0;
		product := 4;
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
		total := total + 2;
	end if;
	if (price < total) then
		next_state <= select_item;
	elsif (price >= total) then
		refund := total - price;
	       if (refund > 0) then
		      next_state <= review;
	       elsif (refund = 0) then
		      next_state <= output;
	       end if;
    end if;
	when review => 
		if (refund >= 4) then
		selectedItem <= "0100";
		refund := refund - 4;
		elsif (refund >= 2) then
		selectedItem <= "0010";
		refund := refund - 2;
		elsif (refund >= 1) then
		selectedItem <= "0001";
		refund := refund - 1;
		else
		selectedItem <= "1111";
		end if;
        next_state <= output;

	when output =>
		if (product = 1) then
		dispense <= "0001";
		elsif (product = 2) then
		dispense <= "0010";
		elsif (product = 3) then
		dispense <= "0100";
		elsif (product = 4) then
		dispense <= "1000";
		end if;
		 
		next_state <= idle;

	---when others => next_state <= idle;
	end case;
  end process;

end VendingData;

