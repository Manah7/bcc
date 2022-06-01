----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:42:24
-- Design Name: 
-- Module Name: banc_registres - Behavioral
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity banc_registres is
    Port ( addr_A : in STD_LOGIC_VECTOR (3 downto 0);
           addr_B : in STD_LOGIC_VECTOR (3 downto 0);
           addr_W : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
end banc_registres;

architecture Behavioral of banc_registres is
    type registers is array (15 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
    signal reg : registers;
begin
process
    begin
     wait until CLK'event and CLK='0';
        if( RST = '0') then reg <= (others => X"00"); end if;
        if( W = '1' ) then
            if(addr_W=addr_A) then
                QA <= DATA;
            elsif (addr_W = addr_B) then
                QB <= DATA;
            end if;
            reg(to_integer(unsigned(addr_W))) <= DATA;
        end if;
    end process;
    QA <= reg(to_integer(unsigned(addr_A)));
    QB <= reg(to_integer(unsigned(addr_B)));
end Behavioral;
