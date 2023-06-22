library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity segmentDisplay is
    Port ( displayA : in STD_LOGIC_VECTOR (3 downto 0);
           displayB : in STD_LOGIC_VECTOR (3 downto 0);
           displayC : in STD_LOGIC_VECTOR (3 downto 0);
           displayD : in STD_LOGIC_VECTOR (3 downto 0);
           Asegment : out STD_LOGIC;
           Bsegment : out STD_LOGIC;
           Csegment : out STD_LOGIC;
           Dsegment : out STD_LOGIC;
           Esegment : out STD_LOGIC;
           Fsegment : out STD_LOGIC;
           Gsegment : out STD_LOGIC;
           select_displayA : out STD_LOGIC;
           select_displayB : out STD_LOGIC;
           select_displayC : out STD_LOGIC;
           select_displayD : out STD_LOGIC;
           clk : in STD_LOGIC);
end segmentDisplay;

architecture Behavioral of segmentDisplay is
component DECODERBIT is
	port(BCD: in std_logic_vector(3 downto 0);
	    segmentA: out std_logic;
	    segmentB: out std_logic;
	    segmentC: out std_logic;
	    segmentD: out std_logic;
	    segmentE: out std_logic;
	    segmentF: out std_logic;
	    segmentG: out std_logic);
end component;

component Multiplexer is
  Port (clk, reset, enable: in std_logic;
   dataCLK: out std_logic_vector(15 downto 0));
end component;
-- declare 3 signals to take data from one module to the other
signal BCD_data: std_logic_vector(3 downto 0);
signal CLK_word: std_logic_vector(15 downto 0); --from the multiplexer
signal slowCLK : std_logic;

begin
DISPLAY: DECODERBIT port map(BCD =>BCD_data, 
                               segmentA => Asegment,
                               segmentB =>Bsegment,
                               segmentC => Csegment, 
                               segmentD => Dsegment, 
                               segmentE => Esegment, 
                               segmentF => Fsegment, 
                               segmentG =>Gsegment);
    --clock_divider to slow down the FPGA clock which is 15MHz 
CLOCK_DIVEDER: Multiplexer port map(clk => clk,
                               reset => '0',
                               enable => '1',
                               dataCLK => CLK_word);
slowCLK <= CLK_word(15);
process(slowCLK)
variable display_selection: std_logic_vector(3 downto 0);
begin
    if(slowCLK'event and slowCLK = '1') then
        case (display_selection) is 
        --for the picking items
        when "0000" => BCD_data <= displayA; 
        -- if select_displayA is set to 0 the display is turned on, 
	--if 1 the display is off
        select_displayA <= '0';
        select_displayB <= '1';
        select_displayC <= '1';
        select_displayD <= '1';
        -- display the next case
        display_selection := display_selection +1;
        
                when "0001" => BCD_data <= displayB;
        -- if select_displayB is set to 0 the display is turned on, 
	--if 1 the display is off
        select_displayA <= '1';
        select_displayB <= '0';
        select_displayC <= '1';
        select_displayD <= '1';
        -- display the next case
        display_selection := display_selection +1;
        
                when "0010" => BCD_data <= displayC;
        -- if select_displayC is set to 0 the display is turned on,
	-- if 1 the display is off
        select_displayA <= '1';
        select_displayB <= '1';
        select_displayC <= '0';
        select_displayD <= '1';
        -- display the next case
        display_selection := display_selection +1;
        
                when "0011" => BCD_data <= displayD;
        -- if select_displayD is set to 0 the display is turned on,
	-- if 1 the display is off
        select_displayA <= '1';
        select_displayB <= '1';
        select_displayC <= '1';
        select_displayD <= '0';
        -- display the next case
        display_selection := display_selection +1;

        end case;
    end if;
end process;
end Behavioral;

