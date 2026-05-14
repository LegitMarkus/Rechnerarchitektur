library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.pkg_riscv_sc.all;

entity alu is
  port(a, b       : in  STD_ULOGIC_VECTOR(31 downto 0);
       ALUControl : in  STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1  downto 0);
       ALUResult  : out STD_ULOGIC_VECTOR(31 downto 0);
       Zero       : out STD_ULOGIC);
end;

architecture bhv of alu is
  signal sum :          STD_ULOGIC_VECTOR(31 downto 0);
begin
  sum <= std_ulogic_vector(unsigned(a) + unsigned(b)) when Alucontrol(0)='0' else  -- a + b
         std_ulogic_vector(unsigned(a) + unsigned(not(b)) + 1);                    -- a + (-b)

  process(a,b,ALUControl,sum) begin
    case ALUControl is
      when ALU_CTRL_ADD | ALU_CTRL_SUB    => ALUResult <= sum;
      when ALU_CTRL_AND                   => ALUResult <= a and b;
      when ALU_CTRL_OR                    => ALUResult <= a or b;
      when ALU_CTRL_SLT                   => ALUResult <= (0 => sum(31), others => '0');
      when others                         => ALUResult <= (others => 'X');
    end case;
  end process;

  Zero      <= '1' when ALUResult = X"00000000" else '0';
  
end;
