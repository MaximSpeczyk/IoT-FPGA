library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Vending_tb is
end Vending_tb;

architecture testbench of Vending_tb is
  -- Constants for test parameters
  constant CLK_PERIOD: time := 10 ns;
  
  -- Component declaration
  component Vending is
    port (
      CLK, reset: in std_logic;
      pickItem: in std_logic_vector(2 downto 0);
      selectedItem: out std_logic_vector(2 downto 0);
      coin_in: in std_logic_vector(3 downto 0);
      dispense: out std_logic_vector(2 downto 0)
    );
  end component;

  -- Signals for test stimulus
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';
  signal pickItem: std_logic_vector(2 downto 0) := (others => '0');
  signal coin_in: std_logic_vector(3 downto 0) := (others => '0');
  
  -- Signals for test verification
  signal selectedItem: std_logic_vector(2 downto 0);
  signal dispense: std_logic_vector(2 downto 0);
  
begin

  -- Instantiate the vending machine
  DUT: Vending
    port map (
      CLK => clk,
      reset => reset,
      pickItem => pickItem,
      selectedItem => selectedItem,
      coin_in => coin_in,
      dispense => dispense
    );
  
  -- Clock generation process
  clk_process: process
  begin
    while now < 50 ns loop
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stimulus_process: process
  begin
    -- Reset the vending machine
    reset <= '1';
    wait for CLK_PERIOD;
    reset <= '0';
    wait for CLK_PERIOD;
    
    -- Test scenario 1: Select item 1, insert enough coins, and verify output
    pickItem <= "001";
    coin_in <= "1110";
    wait for CLK_PERIOD;
    assert selectedItem = "001" report "Test scenario 1 failed: selectedItem mismatch";
    assert dispense = "100" report "Test scenario 1 failed: dispense mismatch";
    
    -- Test scenario 2: Select item 2, insert insufficient coins, and verify output
    pickItem <= "010";
    coin_in <= "0010";
    wait for CLK_PERIOD;
    selectedItem <= "010"; --report "Test scenario 2 failed: selectedItem mismatch";
    assert dispense = "000" report "Test scenario 2 failed: dispense mismatch";
    
    -- Test scenario 3: Select item 3, insert exact coins, and verify output
    pickItem <= "100";
    coin_in <= "0010";
    wait for CLK_PERIOD;
    assert selectedItem <= "100" report "Test scenario 3 failed: selectedItem mismatch";
    assert dispense = "001" report "Test scenario 3 failed: dispense mismatch";
    
    --Additional test scenarios can be added here
    
    -- End the simulation
    wait;
  end process;

end testbench;

