library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sim_CPU is
end sim_CPU;

architecture Behavioral of sim_CPU is

component CPU is
    Port ( 
        CKCPU : in STD_LOGIC;
        RSTCPU : in STD_LOGIC);
end component;

signal clock : std_logic := '0';
signal reset :  std_logic;
begin
    process
        begin
            wait for 100ns;
            if clock = '0' then clock <= '1';
            else clock <= '0'; end if;
    end process;
    reset <= '0', '1' after 200ns;
    cpu_test : CPU port map (CKCPU => clock, RSTCPU => reset);
      
end Behavioral;
