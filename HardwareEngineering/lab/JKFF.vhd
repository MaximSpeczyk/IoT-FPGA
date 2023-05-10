library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JK_FlipFlop is
    Port (
        J : in STD_LOGIC;
        K : in STD_LOGIC;
        CLK : in STD_LOGIC;
        Q : out STD_LOGIC;
        nQ : out STD_LOGIC
    );
end JK_FlipFlop;

architecture behavior of JK_FlipFlop is
    signal Q_int: STD_LOGIC := '0';
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if J = '0' and K = '0' then
                -- No change in output
                Q_int <= Q_int;
            elsif J = '0' and K = '1' then
                -- Reset output
                Q_int <= '0';
            elsif J = '1' and K = '0' then
                -- Set output
                Q_int <= '1';
            else -- J = '1' and K = '1'
                -- Toggle output
                Q_int <= NOT Q_int;
            end if;
        end if;
    end process;

    Q <= Q_int;
    nQ <= NOT Q_int;
end behavior;
