library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_subtractor is
    Port (
        A : in  STD_LOGIC_VECTOR(3 downto 0);
        B : in  STD_LOGIC_VECTOR(3 downto 0);
        mode : in  STD_LOGIC;
        SUM : out  STD_LOGIC_VECTOR(3 downto 0);
        Cout : out  STD_LOGIC
    );
end adder_subtractor;

architecture behavior of adder_subtractor is
    signal ADD, SUB: STD_LOGIC_VECTOR(3 downto 0);
    signal ADD_Cout: STD_LOGIC;

    component ripple_carry_adder
        Port (
            A : in  STD_LOGIC_VECTOR(3 downto 0);
            B : in  STD_LOGIC_VECTOR(3 downto 0);
            SUM : out  STD_LOGIC_VECTOR(3 downto 0);
            Cout : out  STD_LOGIC
        );
    end component;

begin
    -- Addition
    RCA_ADD: ripple_carry_adder
        port map (
            A => A,
            B => B,
            SUM => ADD,
            Cout => ADD_Cout
        );

    -- Subtraction
    SUB <= std_logic_vector(unsigned(A) - unsigned(B));

    process (mode)
    begin
        if mode = '0' then
            SUM <= ADD;
            Cout <= ADD_Cout;
        else
            SUM <= SUB;
            Cout <= '0'; -- Ignoring borrow in this case
        end if;
    end process;
end behavior;
