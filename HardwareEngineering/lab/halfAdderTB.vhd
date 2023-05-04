entity halfAdderTB is
end entity;

architecture bench of halfAdderTB is

component HALFADDER is
   port (A: in bit;
         B: in bit;
         S: out bit;
     C: out bit);
end component;

signal a_t, b_t, s_t, co_t: bit;

begin

uut: HALFADDER port map (a_t, b_t, s_t, co_t);

a_t <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
b_t <= '0', '0' after 20 ns, '1' after 40 ns, '1' after 60 ns;

end architecture;