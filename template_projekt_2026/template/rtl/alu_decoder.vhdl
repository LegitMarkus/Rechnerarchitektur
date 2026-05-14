library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.pkg_riscv_sc.all;

entity alu_decoder is
  port(op_5       : in  STD_ULOGIC;
       funct3     : in  STD_ULOGIC_VECTOR(2 downto 0);
       funct7_5   : in  STD_ULOGIC;
       ALUOp      : in  STD_ULOGIC_VECTOR(1 downto 0);
       ALUControl : out STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1 downto 0));
end;

architecture bhv of alu_decoder is
begin
  process(op_5, funct3, funct7_5, ALUOp) begin
    case ALUOp is
      when "00" => 
        ALUControl <= ALU_CTRL_ADD; -- addition
      when "01" => 
        ALUControl <= ALU_CTRL_SUB; -- subtraction
      when "10" => 
        case funct3 is           -- R-type or I-type ALU
          when "000" =>  if (funct7_5 and op_5) = '1' then
                            ALUControl <= ALU_CTRL_SUB; -- sub
                          else
                            ALUControl <= ALU_CTRL_ADD; -- add, addi
                          end if;
          when "010" =>   ALUControl <= ALU_CTRL_SLT; -- slt, slti
          when "110" =>   ALUControl <= ALU_CTRL_OR; -- or, ori
          when "111" =>   ALUControl <= ALU_CTRL_AND; -- and, andi
          when others =>  ALUControl <= ALU_CTRL_UKNWN; -- unknown
        end case;
      when others => 
        ALUControl <= ALU_CTRL_UKNWN; -- unknown
    end case;
  end process;
end;
