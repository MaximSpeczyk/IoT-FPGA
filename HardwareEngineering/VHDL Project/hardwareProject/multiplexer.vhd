library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- used to slow the clock in display
entity Multiplexer is
  Port (clk, reset, enable: in std_logic;
   dataCLK: out std_logic_vector(15 downto 0));
end Multiplexer;

architecture Behavioral of Multiplexer is

begin
process(clk, reset)
variable counter: std_logic_vector(15 downto 0);
begin
if (reset = '1') then
    counter := (others => '0');
elsif (enable = '1' and clk'event and clk = '1') then
    counter := counter + 1;
end if;
dataCLK <= counter;
end process;

end Behavioral;
