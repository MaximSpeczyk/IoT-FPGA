entity HALFADDER is
    port(A,B: in bit;
    S,C:out bit);
end entity;

architecture Data of HALFADDER is
    begin
        S <= A xor B;
        C <= A and B;
end architecture;