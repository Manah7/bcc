library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity data_memory is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           INPUT : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
end data_memory;

architecture Behavioral of data_memory is
type memory is array (15 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
    signal mem : memory;
begin
process
    begin
     wait until CLK'event and CLK='0';
        if( RST = '0') then mem <= (others => X"00"); end if;
        if( RW = '0' ) then
            mem(to_integer(unsigned(addr))) <= INPUT;
        else 
            OUTPUT <= mem(to_integer(unsigned(addr)));
        end if;
    end process;


end Behavioral;
