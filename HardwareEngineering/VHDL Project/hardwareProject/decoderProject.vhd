library IEEE;
use IEEE.std_logic_1164.all;

entity DECODERBIT is
	port(BCD: in std_logic_vector(3 downto 0);
	    segmentA: out std_logic;
	    segmentB: out std_logic;
	    segmentC: out std_logic;
	    segmentD: out std_logic;
	    segmentE: out std_logic;
	    segmentF: out std_logic;
	    segmentG: out std_logic);
end entity;

architecture DECODERBITDATA of DECODERBIT is
	begin
	process(BCD)
	variable segment: std_logic_vector(6 downto 0);
	begin
		case (BCD) is 
		when "0000" => segment := "1111110"; --0
		when "0001" => segment := "0110000"; --1
		when "0010" => segment := "1101101"; --2
		when "0011" => segment := "1111001"; --3
		when "0100" => segment := "0110011"; --4
		when "0101" => segment := "1011011"; --5
		when "0110" => segment := "1011111"; --6
		when "0111" => segment := "1110000"; --7
		when "1000" => segment := "1111111"; --8
		when "1001" => segment := "1111011"; --9
		when others => segment := "0000000"; --anything else
        end case;
        segmentA <= not segment(6);
        segmentB <= not segment(5);
        segmentC <= not segment(4);
        segmentD <= not segment(3);
        segmentE <= not segment(2);
        segmentF <= not segment(1);
        segmentG <= not segment(0);
        
        end process;
end DECODERBITDATA;
