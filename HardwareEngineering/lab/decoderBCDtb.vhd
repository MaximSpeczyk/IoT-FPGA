entity DecoderBitTest is
end DecoderBitTest;

architecture DecoderBit of DecoderBitTest is


component DECODERBIT is
	port(BCD: in bit_vector(3 downto 0);
	    segment: out bit_vector(6 downto 0));
end component;

signal BCD_t: bit_vector(3 downto 0);
signal segment_t: bit_vector(6 downto 0);

begin

DUT1: DECODERBIT port map (BCD_t, segment_t);

BCD_t <= "0000", "0001" after 20 ns, "0010" after 40 ns, "0011" after 60 ns, "0100" after 80 ns, "0101" after 100 ns, 
	"0110" after 120 ns, "0111" after 140 ns, "1000" after 160 ns, "1001" after 180 ns;

end DecoderBit;
