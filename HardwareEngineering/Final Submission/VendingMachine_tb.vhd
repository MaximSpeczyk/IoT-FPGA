library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VM_tb is
end entity;

architecture testbench of VM_tb is

    -- Component declaration
    component VM is
        port (
             clk, reset: in std_logic;
             coin_in, pickItem: in std_logic_vector(3 downto 0);
             Anode, Cathode: out std_logic_vector(7 downto 0);
             selectedItem, dispense: out std_logic_vector(3 downto 0);
             refundOutLed, idle_state, selected_state, review_state, output_state: out std_logic
        );
    end component;

    -- Signal declarations
    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal coinin_tb : std_logic_vector(3 downto 0);
    signal pickItem_tb : std_logic_vector(3 downto 0);
    signal Anode_tb : std_logic_vector(7 downto 0);
    signal Cathode_tb : std_logic_vector(7 downto 0);
    signal selectedItem_tb : std_logic_vector(3 downto 0);
    signal dispense_tb : std_logic_vector(3 downto 0);
    signal refundOutLed_tb : std_logic;
    signal idle_state_tb, selected_state_tb, review_state_tb, output_state_tb : std_logic;


begin

    -- Instantiate the unit under test (UUT)
    DUT:  VM port map (clk_tb, reset_tb, coinin_tb, pickItem_tb, Anode_tb, Cathode_tb,
selectedItem_tb, dispense_tb, refundOutLed_tb, idle_state_tb, selected_state_tb, review_state_tb);

    -- Clock generation process
    clk_process:     process
    begin
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset
        reset_tb <= '1';
        reset_tb <= '0';
	wait for 10 ns;

        -- Test case 1
        pickItem_tb <= "0000";
        coinin_tb <= "0000";
        wait for 10 ns;

        -- Test case 2
        pickItem_tb <= "0010";
        coinin_tb <= "0010";
       wait for 10 ns;

        -- Test case 3
        pickItem_tb <= "0100";
        coinin_tb <= "0100";
        wait for 10 ns;

       -- Finish the simulation
        wait;
    end process;

end architecture;

