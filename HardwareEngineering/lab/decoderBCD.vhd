entity DECODERBIT is
	port(BCD: in bit_vector(3 downto 0);
	    segment: out bit_vector(6 downto 0));
end entity;

architecture DECODERBITDATA of DECODERBIT is
	begin
		with (BCD) select 
		segment <=  "1111110" when "0000",
			"0110000" when "0001",
			"1101101" when "0010",
			"1111001" when "0011",
			"0110011" when "0100",
			"1011011" when "0101",
			"1011111" when "0110",
			"1110000" when "0111",
			"1111111" when "1000",
			"1111011" when "1001",
			"0000000" when others;
end DECODERBITDATA;
