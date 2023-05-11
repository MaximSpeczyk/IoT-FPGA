library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_subtractor_tb is
end adder_subtractor_tb;

architecture sim of adder_subtractor_tb is
    signal A, B, SUM: STD_LOGIC_VECTOR(3 downto 0);
    signal mode, Cout: STD_LOGIC;

    component adder_subtractor
        Port (
            A : in  STD_LOGIC_VECTOR(3 downto 0);
            B : in  STD_LOGIC_VECTOR(3 downto 0);
            mode : in  STD_LOGIC;
            SUM : out  STD_LOGIC_VECTOR(3 downto 0);
            Cout : out  STD_LOGIC
        );
    end component;

begin
    UUT: adder_subtractor
        port map (
            A => A,
            B => B,
            mode => mode,
            SUM => SUM,
            Cout => Cout
        );

    process
    begin
        -- Test case 1: 4-bit addition
        A <= "0101";
        B <= "0011";
        mode <= '0';  -- Addition
        wait for 10 ns;

        -- Test case 2: 4-bit subtraction
        A <= "0101";
        B <= "0011";
        mode <= '1';  -- Subtraction
        wait for 10 ns;

        -- Test case 3: 4-bit addition with carry-out
        A <= "1101";
        B <= "1011";
        mode <= '0';  -- Addition
        wait for 10 ns;

        -- Test case 4: 4-bit subtraction with negative result
        A <= "0010";
        B <= "0110";
        mode <= '1';  -- Subtraction
        wait for 10 ns;

        -- Other test cases can be added as needed

        wait; 
    end process;
end sim;