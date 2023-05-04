entity fullAdderTB is
end entity;

architecture bench of fullAdderTB is

component FULLADDER is
   port(A: in bit;
        B: in bit;
	Cin: in bit;
	Cout: out bit;
	S: out bit);
end component;

signal a_t, b_t, cin_t, cout_t, s_t: bit;

begin

uut: FULLADDER port map (a_t, b_t, cin_t, cout_t, s_t);

a_t <= '0', '0' after 20 ns, '0' after 40 ns, '0' after 60 ns, '1' after 80 ns, '1' after 100 ns, '1' after 120 ns, '1' after 140 ns, '0' after 160 ns;
b_t <= '0', '0' after 20 ns, '1' after 40 ns, '1' after 60 ns, '0' after 80 ns, '0' after 100 ns, '1' after 120 ns, '1' after 140 ns, '0' after 160 ns;
cin_t <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns, '0' after 80 ns, '1' after 100 ns, '0' after 120 ns, '1' after 140 ns, '0' after 160 ns;

end architecture;