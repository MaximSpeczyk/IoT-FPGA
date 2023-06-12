library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VendingMachine is
    Port (
        clk     : in std_logic; 
        reset   : in std_logic;
        note_in : in std_logic_vector(2 downto 0); -- 1, 2, 5 represented as 001, 010, 101
        item_out: out std_logic;
        return_money: out std_logic_vector(2 downto 0)
    );
end VendingMachine;

architecture Behavior of VendingMachine is
    type state_type is (Waiting, Accepting, Dispensing, Returning);
    signal state : state_type;
    signal total_money : integer range 0 to 7 := 0; -- max money = 5 + 2
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= Waiting;
            total_money <= 0;
        elsif rising_edge(clk) then
            case state is
                when Waiting =>
                    -- State transition: Amount =(1,2,5)
                    if note_in /= "000" then
                        total_money <= to_integer(unsigned(note_in));
                        state <= Accepting;
                    end if;
                when Accepting =>
                    -- State transition: Amount =(1,2,5)
                    if note_in /= "000" then
                        total_money <= total_money + to_integer(unsigned(note_in));
                    end if;
                    -- State transition: cost=2, total_Money >= 2
                    if total_money >= 2 then
                        state <= Dispensing;
                    end if;
                when Dispensing =>
                    -- Dispense item
                    item_out <= '1';
                    state <= Returning;
                when Returning =>
                    -- Return money and reset item_out
                    item_out <= '0';
                    if total_money > 2 then
                        -- State transition: Return = total_Money - 2
                        return_money <= std_logic_vector(to_unsigned(total_money - 2, 3));
                    end if;
                    state <= Waiting;
            end case;
        end if;
    end process;
end Behavior;

