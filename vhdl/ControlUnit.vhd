library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ControlUnit is
  Port (
    PipOut_Op_L_D, PipOut_Op_D_E : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    PipOut_A_L_D, PipOut_A_D_E : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    PipOut_B_L_D, PipOut_B_D_E : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    PipOut_C_L_D, PipOut_C_D_E : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    
    PipOut_Op_E_M : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
     PipOut_A_E_M : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
     PipOut_B_E_M : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
     PipOut_C_E_M : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    NOP : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is
    signal alea, al1, al2 : STD_LOGIC;
    signal pip1_arith : STD_LOGIC;
    signal pip2_arith : STD_LOGIC;
    signal pip3_arith : STD_LOGIC;
begin
        NOP <= alea;

        alea  <= al1 or al2;
        
        -- (ADD,SOU,MUL,LSL,LSR,INF, SUP, EQU)
        pip1_arith <= '1' when (PipOut_Op_L_D = "00000000" or
                         PipOut_Op_L_D = "00000001" or
                         PipOut_Op_L_D = "00000010" or
                         PipOut_Op_L_D = "00000011" or
                         PipOut_Op_L_D = "00000100" or
                         PipOut_Op_L_D = "00000101" or
                         PipOut_Op_L_D = "00000110" or
                         PipOut_Op_L_D = "00000111"
                         ) else '0';

        pip2_arith <= '1' when (PipOut_Op_D_E = "00000000" or
                        PipOut_Op_D_E = "00000001" or
                        PipOut_Op_D_E = "00000010" or
                        PipOut_Op_D_E = "00000011" or
                        PipOut_Op_D_E = "00000100" or
                        PipOut_Op_D_E = "00000101" or
                        PipOut_Op_D_E = "00000110" or
                        PipOut_Op_D_E = "00000111"
                                                  ) else '0';
        pip3_arith <= '1' when (PipOut_Op_E_M = "00000000" or
                        PipOut_Op_E_M = "00000001" or
                        PipOut_Op_E_M = "00000010" or
                        PipOut_Op_E_M = "00000011" or
                        PipOut_Op_E_M = "00000100" or
                        PipOut_Op_E_M = "00000101" or
                        PipOut_Op_E_M= "00000110" or
                        PipOut_Op_E_M= "00000111"
                    )else '0';

                    
        al1 <= '1' when 
            (
            -- cas ou des(inst_1) = src(inst_2) <=> A(pip_2) = B(pip_1)
            -- AFC ou COP ou LDR ou arithmétique puis COP ou STR
            ((PipOut_Op_D_E="00001000" or PipOut_Op_D_E="00001001" or PipOut_Op_D_E="00001110" or pip2_arith ='1') 
                and (PipOut_Op_L_D="00001001" or  PipOut_Op_L_D="00001111" ) 
                and PipOut_A_D_E=PipOut_B_L_D) or
            -- cas ou des(inst_1) = src1(inst_2) ou src1(inst_2) <=> A(pip_2) = B(pip_1) ou C(pip_1)
            --AFC ou COP ou LDR ou arithmétique puis arithmétique (ADD,SOU,MUL,LSL,LSR,INF, SUP, EQU)
            ((PipOut_Op_D_E="00001000" or PipOut_Op_D_E="00001001" or PipOut_Op_D_E="00001110" or pip2_arith ='1') 
                and pip1_arith = '1'
                and (PipOut_A_D_E = PipOut_B_L_D or PipOut_A_D_E = PipOut_C_L_D ))) else '0';
        
        al2 <= '1' when 
                            (
                            -- cas ou des(inst_1) = src(inst_2) <=> A(pip_2) = B(pip_1)
                            -- AFC ou COP ou LDR ou arithmétique puis COP ou STR
                            ((PipOut_Op_E_M="00001000" or PipOut_Op_E_M="00001001" or PipOut_Op_E_M="00001110" or pip3_arith ='1') 
                                and (PipOut_Op_L_D="00001001" or  PipOut_Op_L_D="00001111" ) 
                                and PipOut_A_E_M=PipOut_B_L_D) or
                            -- cas ou des(inst_1) = src1(inst_2) ou src1(inst_2) <=> A(pip_2) = B(pip_1) ou C(pip_1)
                            --AFC ou COP ou LDR ou arithmétique puis arithmétique (ADD,SOU,MUL,LSL,LSR,INF, SUP, EQU)
                            ((PipOut_Op_E_M="00001000" or PipOut_Op_E_M="00001001" or PipOut_Op_E_M="00001110" or pip3_arith ='1') 
                                and pip1_arith = '1'
                                and (PipOut_A_E_M = PipOut_B_L_D or PipOut_A_E_M = PipOut_C_L_D ))) else '0';    
                                                         
                                     
                            -- 00000000 -> ADD
                            -- 00000001 -> SOU
                            -- 00000010 -> MUL
                            -- 00000011 -> LSL
                            -- 00000100 -> LSR
                            -- 00000101 -> INF
                            -- 00000110 -> SUP
                            -- 00000111 -> EQU
                            -- 00001000 -> AFC
                            -- 00001001 -> COP
                            -- 00001010 -> JMP
                            -- 00001011 -> JMF
                            -- 00001100 -> PRI
                            -- 00001101 -> RET
                            -- 00001110 -> LDR
                            -- 00001111 -> STR
                            -- 11111111 -> NOP
end Behavioral;
