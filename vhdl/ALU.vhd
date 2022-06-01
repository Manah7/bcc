library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;


entity ALU is
    Port ( N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           
         
           -- 00000000 -> ADD
           -- 00000001 -> SOU
           -- 00000010 -> MUL
           -- 00000011 -> LSL
           -- 00000100 -> LSR
           -- 00000101 -> INF
           -- 00000110 -> SUP
           -- 00000111 -> EQU
           Ctrl_Alu : in STD_LOGIC_VECTOR (7 downto 0));
end ALU;

architecture Behavioral of ALU is

signal A_aux: STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal B_aux: STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal Ctrl: STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal zero: STD_LOGIC_VECTOR (7 downto 0) := X"00";

signal S_aux: STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal S_mul: STD_LOGIC_VECTOR (15 downto 0) := X"0000";

begin
    process(A_aux, B_Aux, Ctrl)
    begin
    case Ctrl is
        when "00000000" => S_aux <= A_aux + B_aux; if (unsigned(B_aux) + unsigned(A_aux) > 255) then C <= '1'; O <= '1'; end if;
        when "00000001" => S_aux <= A_aux - B_aux; if (unsigned(B_aux) > unsigned(A_aux)) then N <= '1'; end if;
        when "00000010" => S_mul <= (A_aux * B_aux); S_aux <= S_mul(7 downto 0); if (S_mul(15 downto 8) /= zero) then O <= '1'; end if;
        --when "011" => S_aux <= A_aux / B_aux;
        
        --when "100" => S_aux <= A_aux(7 - to_integer(unsigned(B_aux)) downto 0) & zero((to_integer(unsigned(B_aux)) - 1) downto 0) ; 
        --    if (unsigned(A_aux(7 downto to_integer(unsigned(B_aux)))) /= 0 ) then O <= '1'; end if;
            
        when "00000011" => S_aux <= std_logic_vector(shift_left(unsigned(A_aux), to_integer(unsigned(B_aux))));
            if (unsigned(A_aux(7 downto to_integer(unsigned(B_aux)))) /= 0 ) then O <= '1'; end if;
                    
        -- when "101" => S_aux <= zero(7 downto (7 - to_integer(unsigned(B_aux)))) & A_aux(7 downto to_integer(unsigned(B_aux))) ;
        when "00000100" => S_aux <= std_logic_vector(shift_right(unsigned(A_aux), to_integer(unsigned(B_aux))));
        
        when "00000101" => if(A_aux< B_Aux) then S_aux <= X"1";  else S_aux <= X"0"; end if;
        when "00000110" => if(A_aux> B_Aux) then S_aux <= X"1";  else S_aux <= X"0"; end if;
        when "00000111" => if(A_aux= B_Aux) then S_aux <= X"1";  else S_aux <= X"0"; end if;
        
        when others => S_aux <= A;
    end case; 
    
    if (S_aux = zero) then
        Z <= '1'; 
    end if;
 
    end process;
    A_aux <= A;
    B_aux <= B;
    Ctrl <= Ctrl_Alu;
    
    S <= S_aux;
end Behavioral;
