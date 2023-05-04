entity FOURBITFULLADDER is
	port(A1, B1, A2, B2, A3, B3, A4, B4: in bit;
	 S1, S2, S3, S4, cout: out bit);
end entity;

architecture FOURBITFULLADDERData of FOURBITFULLADDER is
component FULLADDER is 
	port(A,B,Cin: in bit;
	S,Cout: out bit);
end component;

signal Co1, Co2, Co3: bit;

	begin

FULLADDER1: FULLADDER port map(A1,B1,'0' ,S1,Co1);
FULLADDER2: FULLADDER port map(A2, B2, co1, S2, Co2);
FULLADDER3: FULLADDER port map(A3, B3,co2, S3, Co3);
FULLADDER4: FULLADDER port map(A4, B4,co3, S4, Cout);	

end architecture;
