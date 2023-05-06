entity FULLADDER is
	port(A,B,Cin: in bit;
	S,Cout: out bit);
end entity;

architecture Data of FULLADDER is 
component HALFADDER is
	port(A,B: in bit;
	S,C: out bit);
end component;

signal S1,C1,C2: bit;

begin
	HALFADDER1: HALFADDER port map(A,B,S1,C1);
	HALFADDER2: HALFADDER port map(S1, Cin,S,C2);
	Cout <= C1 or C2;
end architecture;