library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity instructions_memory is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (31 downto 0));
end instructions_memory;

-- 00 -> ADD
-- 01 -> SOU
-- 02 -> MUL
-- 03 -> LSL
-- 04 -> LSR
-- 05 -> INF
-- 06 -> SUP
-- 07 -> EQU
-- 08 -> AFC
-- 09 -> COP
-- 0a -> JMP
-- 0b -> JMF
-- 0c -> PRI
-- 0d -> RET
-- 0e -> LDR
-- 0f -> STR
-- ff -> NOP

architecture Behavioral of instructions_memory is
type memory is array (0 to 255) of STD_LOGIC_VECTOR (31 downto 0);
    -- Exemple de code pour gestion des aléas
   signal mem : memory := ((x"ff000000"),(x"08010c00"),(x"09030100"),others => (x"ff000000"));
begin

    OUTPUT <= mem(to_integer(unsigned(addr)));

end Behavioral;
