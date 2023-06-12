LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY vending_machine_tb IS
END vending_machine_tb;

ARCHITECTURE behavior OF vending_machine_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT vending_machine
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         money_in : IN  std_logic_vector(2 downto 0);
         item_out : OUT  std_logic;
         return_money : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal money_in : std_logic_vector(2 downto 0) := (others => '0');

    --Outputs
   signal item_out : std_logic;
   signal return_money : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: vending_machine PORT MAP (
          clock => clock,
          reset => reset,
          money_in => money_in,
          item_out => item_out,
          return_money => return_money
        );

	-- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;  
      
      reset <= '0'; 
      
      -- insert money 1
      money_in <= "001"; 
      wait for 10 ns;

      -- insert money 2
      money_in <= "010"; 
      wait for 10 ns;
      
      -- insert money 5
      money_in <= "101"; 
      wait for 10 ns;
      
      -- no more money inserted
      money_in <= "000";
      wait for 100 ns;
      
      -- insert money 2
      money_in <= "010"; 
      wait for 10 ns;
      
      -- no more money inserted
      money_in <= "000";
      wait for 100 ns;
      
      wait;
   end process;

END;
