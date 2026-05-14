library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_textio.all;
use STD.TEXTIO.all;
use work.pkg_riscv_sc.all;

entity register_file is -- three-port register file
  generic ( REGISTERS : string);
  port    ( clk, reset: in  STD_ULOGIC;
            A1, A2, A3: in  STD_ULOGIC_VECTOR(4  downto 0);
            WE3       : in  STD_ULOGIC;
            WD3       : in  STD_ULOGIC_VECTOR(31 downto 0);
            RD1, RD2  : out STD_ULOGIC_VECTOR(31 downto 0);
            ram_regs  : out regs_ram);
end;

architecture bhv of register_file is
  impure function init_regs_ram return regs_ram is
    file text_file      : text open read_mode is REGISTERS;
    variable text_line  : line;
    variable ram_content: regs_ram := (others => (others => '0'));
    variable i          : integer := 0;
  begin
    while not endfile(text_file) loop -- set contents from file
        readline(text_file, text_line);
        --report text_line.all;
        hread(text_line, ram_content(i));
        i := i+1;
    end loop;     
    return ram_content;
  end function;
begin
  -- three ported register file
  -- read two ports combinationally (A1/RD1, A2/RD2)
  -- write third port on rising edge of clock (A3/WD3/WE3)
  -- register 0 hardwired to 0
  process(clk, reset) 
  begin
    if reset = '1' then
      ram_regs <= init_regs_ram;
    else
      if rising_edge(clk) then
        if WE3='1' then ram_regs(to_integer(unsigned(A3))) <= WD3;
        end if;
      end if;
    end if;
  end process;

  process(A1, A2, ram_regs) begin
    if not Is_X(A1) then
      if (to_integer(unsigned(A1))=0) then RD1 <= X"00000000";
      else RD1 <= ram_regs(to_integer(unsigned(A1)));
      end if;
    end if;
    if not Is_X(A2) then
      if (to_integer(unsigned(A2))=0) then RD2 <= X"00000000";
      else RD2 <= ram_regs(to_integer(unsigned(A2)));
      end if;
    end if;
  end process;
  
end;
