library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_textio.all;
use work.pkg_riscv_sc.all;

entity instruction_memory is 
  generic ( TEXT_SEGMENT: string);
  port    ( reset       : in  STD_ULOGIC;
            A           : in  STD_ULOGIC_VECTOR(31 downto 0);
            RD          : out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture bhv of instruction_memory is  
  impure function init_imem_ram return imem_ram is
    file text_file      : text open read_mode is TEXT_SEGMENT;
    variable text_line  : line;
    variable ram_content: imem_ram := (others => (others => '0'));
    variable i          : integer := 0; 
  begin
    while not endfile(text_file) loop
      readline(text_file, text_line);
      hread(text_line, ram_content(i));
      i := i+1;
    end loop;
    return ram_content;
  end function;
  signal ram_imem : imem_ram;
begin
  process(reset, A) 
  begin 
    if Is_X(A)      then  RD <= (others => '0');
    else
      if    reset = '1'  then  ram_imem <= init_imem_ram;
      else                     RD <= ram_imem(to_integer(unsigned(calc_relative_address(A, TEXT_SEGMENT_START)(31 downto 2))));
      end if;
    end if;
  end process;
end;
