library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MUX2 is
  port(a, b: in  std_ulogic;
       s:    in  std_ulogic; 
       y:    out std_ulogic);
end;
--end entity;
--end MUX2;
--end entity MUX2;

architecture struct of MUX2 is
begin
  y <= (a and s) or (b and (not s));
  
end;
--end architecture;
--end bhv;
--end architecture bhv;


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MUX2_gen is
  generic(width : integer := 2);
  port(a, b: in  std_ulogic_vector(width-1 downto 0);
       s:    in  std_ulogic; 
       y:    out std_ulogic_vector(width-1 downto 0));
end;
--end entity;
--end MUX2;
--end entity MUX2;

architecture struct of MUX2_gen is
begin
  y <= (a and (not (width-1 downto 0 => s))) or (b and (width-1 downto 0 => s));
  
end;
--end architecture;
--end bhv;
--end architecture bhv;


