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
begin
  process(op) begin
    RegWrite  <= '0';
    ImmSrc    <= EXT_I_TYPE;
    ALUSrc    <= '0';
    MemWrite  <= '0';
    ResultSrc <= "00";
    Branch    <= '0';
    ALUOp     <= "00";
    Jump      <= '0';
    g_ecall   <= '0';

    case op is
      when "0000011" => -- lw, lbu
        RegWrite  <= '1';
        ImmSrc    <= EXT_I_TYPE;
        ALUSrc    <= '1';
        ResultSrc <= "01";

      when "0100011" => -- sw
        ImmSrc    <= EXT_S_TYPE;
        ALUSrc    <= '1';
        MemWrite  <= '1';

      when "0110011" => -- R-type
        RegWrite  <= '1';
        ALUOp     <= "10";

      when "1100011" => -- beq
        ImmSrc    <= EXT_B_TYPE;
        Branch    <= '1';
        ALUOp     <= "01";

      when "0010011" => -- I-type ALU
        RegWrite  <= '1';
        ImmSrc    <= EXT_I_TYPE;
        ALUSrc    <= '1';
        ALUOp     <= "10";

      when "1101111" => -- jal
        RegWrite  <= '1';
        ImmSrc    <= EXT_J_TYPE;
        ResultSrc <= "10";
        Jump      <= '1';

      when "1100111" => -- jalr
        RegWrite  <= '1';
        ImmSrc    <= EXT_I_TYPE;
        ALUSrc    <= '1';
        ResultSrc <= "10";
        Jump      <= '1';

      when "0010111" => -- auipc
        RegWrite  <= '1';
        ImmSrc    <= EXT_U_TYPE;
        ResultSrc <= "11";

      when "1110011" => -- ECALL
        g_ecall   <= '1';

      when others =>
        RegWrite  <= '-';
        ImmSrc    <= (others => '-');
        ALUSrc    <= '-';
        MemWrite  <= '-';
        ResultSrc <= (others => '-');
        Branch    <= '-';
        ALUOp     <= (others => '-');
        Jump      <= '-';
        g_ecall   <= '-';
    end case;
  end process;
end;
