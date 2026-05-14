library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;
use work.pkg_riscv_sc.all;

entity data_memory is
  generic ( DATA_SEGMENT    : string);
  port    ( clk, reset, WE  : in  STD_ULOGIC;
            A, WD           : in  STD_ULOGIC_VECTOR(31 downto 0);
            RD              : out STD_ULOGIC_VECTOR(31 downto 0);
            ram_dmem        : out dmem_ram);
end;

architecture bhv of data_memory is
  impure function init_dmem_ram return dmem_ram is
    file text_file        : text open read_mode is DATA_SEGMENT;
    variable text_line    : line;
    variable address      : std_ulogic_vector(31 downto 0);
    variable value        : std_ulogic_vector(31 downto 0);
    variable ram_content  : dmem_ram := (others => (others => '0'));
  begin
    while not endfile(text_file) loop 
        readline(text_file, text_line);
        hread(text_line, address);
        hread(text_line, value);
        ram_content(to_integer(unsigned(calc_relative_address(address, DATA_SEGMENT_START)(31 downto 2)))) := value;
    end loop;
    return ram_content;
  end function;
begin
  process(clk, reset, A) 
  begin
    if reset = '1' then 
      ram_dmem <= init_dmem_ram;
    else
      if Is_X(A) then RD <= (others => '0');
      else
        if rising_edge(clk) and WE='1' then
          ram_dmem(to_integer(unsigned(calc_relative_address(A, DATA_SEGMENT_START)(15 downto 2)))) <= WD;
        end if;
        RD <= ram_dmem(to_integer(unsigned(calc_relative_address(A, DATA_SEGMENT_START)(15 downto 2))));
      end if;
    end if;
  end process;
end;
