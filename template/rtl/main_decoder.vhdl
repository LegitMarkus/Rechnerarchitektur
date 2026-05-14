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
  signal controls: STD_ULOGIC_VECTOR(12 downto 0);
begin
  process(op) begin
    case op is
      when "0000011" => controls <= "1000100100000"; -- lw, lbu
      when "0100011" => controls <= "000111--00000"; -- sw
      when "0110011" => controls <= "1---000001000"; -- R-type
      when "1100011" => controls <= "0010000010100"; -- beq
      when "0010011" => controls <= "1000100001000"; -- I-type ALU
      when "1101111" => controls <= "1011001000010"; -- jal
      when "1100111" => controls <= "1000101000010"; -- jalr
      when "0010111" => controls <= "1100001100000"; -- auipc
      when "1110011" => controls <= "0000000000001"; -- ECALL
      when others    => controls <= "-------------"; -- not valid
    end case;
  end process;

  (RegWrite, ImmSrc(2), ImmSrc(1), ImmSrc(0), ALUSrc, MemWrite, ResultSrc(1), ResultSrc(0), Branch, ALUOp(1), ALUOp(0), Jump, g_ecall) <= controls;
end;
