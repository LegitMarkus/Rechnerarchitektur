library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity setableshiftreg is 
  generic(width: integer);
  port(clk, set: in std_ulogic;
       d:        in std_ulogic_vector(width-1 downto 0);
       q:       out std_ulogic);
end;

architecture bhv of setableshiftreg is
  
    signal qq: std_ulogic_vector(width-1 downto 0);
    
begin
  
  process(clk)
  begin
    if clk'event and clk='1' then
      if set = '1' then
        qq <= d;
      else
        qq <= '0' & qq(width-1 downto 1);
      end if;
    end if;
  end process;
  
  q <= qq(0);
  
end;
