library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;



entity IP is
port ( CK : in STD_LOGIC;
       RST : in STD_LOGIC;
       LOAD : in STD_LOGIC;
       EN : in STD_LOGIC;
       Din : in STD_LOGIC_VECTOR (7 downto 0);
       Dout : out STD_LOGIC_VECTOR (7 downto 0));
end IP;

architecture Behavioral of IP is
    signal Aux: STD_LOGIC_VECTOR (7 downto 0) := X"00";
begin
process
    begin
            wait until CK'Event and CK = '1';
            
            if (RST = '0') then
                Aux <= X"00";
            elsif (LOAD = '1') then
                Aux <= Din;
            elsif (EN = '0') then
                Aux <= (Aux + 1);
            end if;
    end process;
    Dout <= Aux;

end Behavioral;
