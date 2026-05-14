library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.pkg_riscv_sc.all;

entity extend is -- extend unit
  port(instr  : in  STD_ULOGIC_VECTOR(31 downto 7);
       immsrc : in  STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1  downto 0);
       immext : out STD_ULOGIC_VECTOR(31 downto 0));
end;
    
architecture bhv of extend is
begin
  process(instr, immsrc) begin
    case immsrc is
      when EXT_I_TYPE =>
        immext <= (31 downto 12 => instr(31)) & instr(31 downto 20);
      when EXT_S_TYPE =>
        immext <= (31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
      when EXT_B_TYPE =>
        immext <= (31 downto 12 => instr(31)) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';
      when EXT_J_TYPE =>
        immext <= (31 downto 20 => instr(31)) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0';
      when others =>
        immext <= (31 downto 0 => 'X');
    end case;
  end process;
end;
