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
           CLK : in STD_LOGIC;
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
           
signal point_addr: STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal jump_addr: STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal jump : STD_LOGIC := '0';

signal out_opp : STD_LOGIC_VECTOR (31 downto 0) := X"00000000";

-- Sorties pipelines
signal PipOut_Op_L_D, PipOut_Op_D_E, PipOut_Op_E_M, PipOut_Op_M_R : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal PipOut_A_L_D, PipOut_A_D_E, PipOut_A_E_M , PipOut_A_M_R : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal PipOut_B_L_D, PipOut_B_D_E, PipOut_B_E_M , PipOut_B_M_R : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal PipOut_C_L_D, PipOut_C_D_E, PipOut_C_E_M , PipOut_C_M_R : STD_LOGIC_VECTOR (7 downto 0) := X"00";

--ELLEMENTS

--banc registre
signal Mux_regi : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal reg_wr : STD_LOGIC;
signal reg_data, reg_A, reg_B : STD_LOGIC_VECTOR(7 downto 0 );

--UAL
signal N_flag, O_flag, Z_flag, C_flag : STD_LOGIC;
signal UAL_result : STD_LOGIC_VECTOR(7 downto 0 );

-- mémoire de données
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
    EN => '0', 
    LOAD => jump);

pip_LI_DI : pipeline port map (
    IN_A => out_opp(23 downto 16),
    IN_B => out_opp(15 downto 8),
    IN_C => out_opp(7 downto 0),
    IN_OPP => out_opp(31 downto 24),
    OUT_A => PipOut_A_L_D,
    OUT_B => PipOut_B_L_D,
    OUT_C => PipOut_C_L_D,
    OUT_OPP => PipOut_Op_L_D,
    CLK => CKCPU);


pip_DI_EX : pipeline port map (
    IN_A => PipOut_A_L_D,
    IN_B => Mux_regi,
    IN_C => PipOut_C_L_D,
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
    addr => PipOut_B_E_M,
    INPUT => PipOut_A_E_M,
    RW => mem_RW,
    RST => RSTCPU,
    CLK => CKCPU,
    OUTPUT => mem_out
);
pip_Mem_RE : pipeline port map (
    IN_A => PipOut_A_E_M,
    IN_B => PipOut_B_E_M,
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
    CLK => CKCPU,
    OUTPUT => out_opp);
    
-- Banc de registre :
    Mux_regi <= reg_A when PipOut_Op_L_D = "00001001" else PipOut_B_L_D; --Si COP lecture au lieu de passer l'info
    reg_wr <= '1' when PipOut_Op_M_R = "00001000" else '0'; -- Si AFC ecriture
--  UAL
    --Multiplxeur et autre implémenté directement dans l'UAL
-- Mémoire de données :
    mem_RW <= '0' when PipOut_Op_E_M = "00001111" else '1'; --0 store 1 load
    Mux_mem2 <= mem_out when  PipOut_Op_E_M = "00001110" else PipOut_B_E_M;
    --Mux_mem1 <= PipOut_A_E_M when PipOut_Op_E_M else PipOut_B_E_M when ;


end Behavioral;
