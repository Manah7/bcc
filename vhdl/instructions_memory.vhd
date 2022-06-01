library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity instructions_memory is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (31 downto 0));
end instructions_memory;

architecture Behavioral of instructions_memory is
type memory is array (0 to 255) of STD_LOGIC_VECTOR (31 downto 0);
   signal mem : memory := ((x"ff000000"),(x"08010200"), others => (x"ff000000"));
begin
process
    begin
     wait until CLK'event and CLK='1';
            OUTPUT <= mem(to_integer(unsigned(addr)));
    end process;
    

end Behavioral;
