library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity load_extend is
  port(funct3     : in  STD_ULOGIC_VECTOR(2 downto 0);
       address    : in  STD_ULOGIC_VECTOR(1 downto 0);
       readdata   : in  STD_ULOGIC_VECTOR(31 downto 0);
       loadresult : out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture bhv of load_extend is
begin
  process(funct3, address, readdata) begin
    if funct3 = "100" then -- lbu
      case address is
        when "00" => loadresult <= X"000000" & readdata(7 downto 0);
        when "01" => loadresult <= X"000000" & readdata(15 downto 8);
        when "10" => loadresult <= X"000000" & readdata(23 downto 16);
        when "11" => loadresult <= X"000000" & readdata(31 downto 24);
        when others => loadresult <= (others => 'X');
      end case;
    else
      loadresult <= readdata;
    end if;
  end process;
end;
