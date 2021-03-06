----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 11:54:34
-- Design Name: 
-- Module Name: CPU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU is
    Port ( 
        CKCPU : in STD_LOGIC;
        RSTCPU : in STD_LOGIC);
end CPU;

architecture Behavioral of CPU is
component IP is
port ( CK : in STD_LOGIC;
       RST : in STD_LOGIC;
           LOAD : in STD_LOGIC;
           EN : in STD_LOGIC;
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component ALU is
    Port ( N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in STD_LOGIC_VECTOR (7 downto 0));
end component;
component pipeline is
    Port ( IN_A : in STD_LOGIC_VECTOR (7 downto 0);
           IN_B : in STD_LOGIC_VECTOR (7 downto 0);
           IN_C : in STD_LOGIC_VECTOR (7 downto 0);
           IN_OPP : in STD_LOGIC_VECTOR (7 downto 0);
           OUT_A : out STD_LOGIC_VECTOR (7 downto 0);
           OUT_B : out STD_LOGIC_VECTOR (7 downto 0);
           OUT_C : out STD_LOGIC_VECTOR (7 downto 0);
           OUT_OPP : out STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC);
end component;
component banc_registres is
    Port ( addr_A : in STD_LOGIC_VECTOR (3 downto 0);
           addr_B : in STD_LOGIC_VECTOR (3 downto 0);
           addr_W : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component instructions_memory is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (31 downto 0));
end component;
component data_memory is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           INPUT : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component ControlUnit is
  Port (
    PipOut_Op_L_D, PipOut_Op_D_E, PipOut_Op_E_M : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    PipOut_A_L_D, PipOut_A_D_E, PipOut_A_E_M  : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    PipOut_B_L_D, PipOut_B_D_E, PipOut_B_E_M  : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    PipOut_C_L_D, PipOut_C_D_E, PipOut_C_E_M  : in STD_LOGIC_VECTOR (7 downto 0) := X"00";
    NOP : out STD_LOGIC);
end component;

-- Convention jeu instruction :
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
           -- 
signal clock_monitored : STD_LOGIC;
signal nope : STD_LOGIC;
signal point_addr: STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal jump_addr: STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal jump : STD_LOGIC := '0';

signal out_opp : STD_LOGIC_VECTOR (31 downto 0) := X"00000000";

-- Sorties pipelines
signal PipOut_Op_L_D, PipOut_Op_D_E, PipOut_Op_E_M, PipOut_Op_M_R : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal PipOut_A_L_D, PipOut_A_D_E, PipOut_A_E_M , PipOut_A_M_R : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal PipOut_B_L_D, PipOut_B_D_E, PipOut_B_E_M , PipOut_B_M_R : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal PipOut_C_L_D, PipOut_C_D_E, PipOut_C_E_M , PipOut_C_M_R : STD_LOGIC_VECTOR (7 downto 0) := X"00";

--sortie du premier pipeline ?? controler par la CU
signal OPP_LI_DI : STD_LOGIC_VECTOR (7 downto 0) := X"00";
--ELLEMENTS

--banc registre
signal Mux_regi : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal reg_wr : STD_LOGIC;
signal reg_data, reg_A, reg_B : STD_LOGIC_VECTOR(7 downto 0 );

--UAL
signal N_flag, O_flag, Z_flag, C_flag : STD_LOGIC;
signal UAL_result : STD_LOGIC_VECTOR(7 downto 0 );

-- m??moire de donn??es
signal mem_rw : STD_LOGIC;
signal Mux_mem1 : STD_LOGIC_VECTOR(7 downto 0 );
signal Mux_mem2 : STD_LOGIC_VECTOR(7 downto 0 );
signal mem_out : STD_LOGIC_VECTOR(7 downto 0 );
begin

inst_point : IP port map ( 
    CK=> CKCPU, 
    Dout=> point_addr, 
    Din => jump_addr, 
    RST => RSTCPU, 
    EN => nope, 
    LOAD => jump);

pip_LI_DI : pipeline port map (
    IN_A => out_opp(23 downto 16),
    IN_B => out_opp(15 downto 8),
    IN_C => out_opp(7 downto 0),
    IN_OPP => OPP_LI_DI,
    OUT_A => PipOut_A_L_D,
    OUT_B => PipOut_B_L_D,
    OUT_C => PipOut_C_L_D,
    OUT_OPP => PipOut_Op_L_D,
    CLK => CKCPU);


pip_DI_EX : pipeline port map (
    IN_A => PipOut_A_L_D,
    IN_B => Mux_regi,
    IN_C => reg_B,
    IN_OPP => PipOut_Op_L_D,
    OUT_A => PipOut_A_D_E,
    OUT_B => PipOut_B_D_E,
    OUT_C => PipOut_C_D_E,
    OUT_OPP => PipOut_Op_D_E,
    CLK => CKCPU);
    
ual : ALU port map(
        N => N_Flag,
        O => O_Flag,
        Z => Z_Flag,
        C => C_Flag,
        A => PipOut_B_D_E,
        B => PipOut_C_D_E,
        S => UAL_result,
        Ctrl_Alu => PipOut_Op_D_E);
        
pip_EX_Mem : pipeline port map (
    IN_A => PipOut_A_D_E,
    IN_B => UAL_result,
    IN_C => PipOut_C_D_E,
    IN_OPP => PipOut_Op_D_E,
    OUT_A => PipOut_A_E_M,
    OUT_B => PipOut_B_E_M,
    OUT_C => PipOut_C_E_M,
    OUT_OPP => PipOut_Op_E_M,
    CLK => CKCPU);
    
data_mem : data_memory port map (
    addr => Mux_mem1,
    INPUT => PipOut_B_E_M,
    RW => mem_RW,
    RST => RSTCPU,
    CLK => CKCPU,
    OUTPUT => mem_out
);
pip_Mem_RE : pipeline port map (
    IN_A => PipOut_A_E_M,
    IN_B => Mux_mem2,
    IN_C => PipOut_C_E_M,
    IN_OPP => PipOut_Op_E_M,
    OUT_A => PipOut_A_M_R,
    OUT_B => PipOut_B_M_R,
    OUT_C => PipOut_C_M_R,
    OUT_OPP => PipOut_Op_M_R,
    CLK => CKCPU);

register_bench : banc_registres port map (
    addr_A => PipOut_B_L_D(3 downto 0),
    addr_B => PipOut_C_L_D(3 downto 0),
    addr_W => PipOut_A_M_R(3 downto 0),
    W => reg_wr,
    DATA => PipOut_B_M_R,
    RST => RSTCPU,
    CLK => CKCPU,
    QA => reg_A,
    QB => reg_B);

instru_mem :  instructions_memory  port map(
    addr => point_addr,
    OUTPUT => out_opp);
    

CU : ControlUnit port map (
   PipOut_Op_L_D => out_opp(31 downto 24), PipOut_Op_D_E => PipOut_Op_L_D,
   PipOut_A_L_D => out_opp(23 downto 16), PipOut_A_D_E => PipOut_A_L_D,
   PipOut_B_L_D => out_opp(15 downto 8), PipOut_B_D_E => PipOut_B_L_D,
   PipOut_C_L_D => out_opp(7 downto 0), PipOut_C_D_E => PipOut_C_L_D,
   PipOut_Op_E_M => PipOut_Op_D_E, 
        PipOut_A_E_M => PipOut_A_D_E,
        PipOut_B_E_M => PipOut_B_D_E, 
        PipOut_C_E_M => PipOut_C_D_E, 
   NOP => nope);
   
 -- injection de nop si al??a
 OPP_LI_DI<= X"ff" when nope='1' else out_opp(31 downto 24);

-- Banc de registre :
    -- Si AFC (stockage dans les registres) on passe la valeur, 
    -- Si LDR (load depuis la memoire) on passe l'adresse mem, sinon on passe la valeur ?? l'adresse
    Mux_regi <= PipOut_B_L_D when 
        PipOut_Op_L_D = "00001000" or
        PipOut_Op_L_D = "00001110" 
        -- sinon on fait passer la valeur stock?? ?? l'adresse de B
        else reg_A; 
        
    reg_wr <= '0' when 
        PipOut_Op_M_R = "00001111" or -- STR
        PipOut_Op_M_R = "00001010" or -- JMP
        PipOut_Op_M_R = "00001011" or -- JMF
        PipOut_Op_M_R = "00001100" or -- PRI
        PipOut_Op_M_R = "11111111" or   -- NOP
        PipOut_Op_M_R = "UUUUUUUU"
        else '1'; -- AFC, COP, ADD, MUL, SUB, SUP ...
        
--  UALSS
    --Multiplxeur et autre impl??ment?? directement dans l'UAL
    
-- M??moire de donn??es :
    mem_RW <= '0' when PipOut_Op_E_M = "00001111" else '1'; --0 store 1 load
    
    --Lecture de la m??moire si LDR
    Mux_mem2 <= mem_out when  PipOut_Op_E_M = "00001110" else PipOut_B_E_M;
    
    -- Adresse d'??criture = A si STR
    Mux_mem1 <= PipOut_A_E_M when PipOut_Op_E_M = "00001111" else PipOut_B_E_M ;


end Behavioral;
