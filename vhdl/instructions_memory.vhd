----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 11:24:40
-- Design Name: 
-- Module Name: instructions_memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.use IEEE.NUMERIC_STD.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity instructions_memory is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (31 downto 0));
end instructions_memory;

architecture Behavioral of instructions_memory is
type memory is array (0 to 255) of STD_LOGIC_VECTOR (31 downto 0);
   --signal mem : memory := (         (x"ff000000"),         (x"08010200"),         (x"0f010800"),         (x"0f010400"),         (x"08020300"),         (x"0f020800"),         (x"00030101"),         (x"0f030400"),         (x"08040800"),         (x"0f041000"),         (x"0f040c00"),         (x"0e050400"),         (x"00050305"),         (x"0f051800"),         (x"0f051400"),          others => (x"ff000000"));
   signal mem : memory := ((x"ff000000"),(x"08010200"), others => (x"ff000000"));
begin
process
    begin
     wait until CLK'event and CLK='1';
            OUTPUT <= mem(to_integer(unsigned(addr)));
    end process;
    

end Behavioral;
