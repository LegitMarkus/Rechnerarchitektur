library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.pkg_riscv_sc.all;

entity main_decoder is 
  port(op             : in  STD_ULOGIC_VECTOR(6 downto 0); 
       ResultSrc      : out STD_ULOGIC_VECTOR(1 downto 0);
       MemWrite       : out STD_ULOGIC;
       Branch, ALUSrc : out STD_ULOGIC;
       RegWrite, Jump : out STD_ULOGIC;
       ImmSrc         : out STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1 downto 0);
       ALUOp          : out STD_ULOGIC_VECTOR(1 downto 0));
end;

architecture bhv of main_decoder is
  signal controls: STD_ULOGIC_VECTOR(11 downto 0);
begin
  process(op) begin
    case op is
      when "0000011" => controls <= "100100100000"; -- lw
      when "0100011" => controls <= "001110000000"; -- sw
      when "0110011" => controls <= "1--000001000"; -- R-type
      when "1100011" => controls <= "010000010100"; -- beq
      when "0010011" => controls <= "100100001000"; -- I-type ALU
      when "1101111" => controls <= "111001000010"; -- jal
      when "1110011" => controls <= "0--00--00001"; -- ECALL
      when others    => controls <= "------------"; -- not valid
    end case;
  end process;

  (RegWrite, ImmSrc(1), ImmSrc(0), ALUSrc, MemWrite, ResultSrc(1), ResultSrc(0), Branch, ALUOp(1), ALUOp(0), Jump, g_ecall) <= controls;
end;
