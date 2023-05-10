library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JK_FlipFlop_tb is
end JK_FlipFlop_tb;

architecture sim of JK_FlipFlop_tb is
    signal J, K, CLK, Q, nQ: STD_LOGIC;

    component JK_FlipFlop
        Port (
            J : in STD_LOGIC;
            K : in STD_LOGIC;
            CLK : in STD_LOGIC;
            Q : out STD_LOGIC;
            nQ : out STD_LOGIC
        );
    end component;

begin
    DUT: JK_FlipFlop
        port map (
            J => J,
            K => K,
            CLK => CLK,
            Q => Q,
            nQ => nQ
        );

    process
    begin
        -- Initialize signals
        J <= '0';
        K <= '0';
        CLK <= '0';
        wait for 10 ns;

        -- Test 1: J = 0, K = 0 (No change)
        CLK <= '1';
        wait for 10 ns;
        CLK <= '0';
        wait for 10 ns;

        -- Test 2: J = 0, K = 1 (Reset)
        K <= '1';
        CLK <= '1';
        wait for 10 ns;
        CLK <= '0';
        wait for 10 ns;

        -- Test 3: J = 1, K = 0 (Set)
        J <= '1';
        K <= '0';
        CLK <= '1';
        wait for 10 ns;
        CLK <= '0';
        wait for 10 ns;

        -- Test 4: J = 1, K = 1 (Toggle)
        K <= '1';
        CLK <= '1';
        wait for 10 ns;
        CLK <= '0';
        wait for 10 ns;

        -- Test 5: Toggle again
        CLK <= '1';
        wait for 10 ns;
        CLK <= '0';
        wait for 10 ns;

        -- End of simulation
        assert false report "End of simulation" severity FAILURE;
    end process;
end sim;
