library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity shiftreg is 
  generic(width: integer);
  port(clk: in std_ulogic;
       d:   in std_ulogic;
       q:  out std_ulogic_vector(width-1 downto 0));
end;

architecture struct of shiftreg is 
  component ff
    port(clk, reset: in std_ulogic;
         d:          in std_ulogic;
         q:         out std_ulogic);
    end component;
  
begin
  
  ff_n: ff port map(clk, '0', d, q(width-1));
  
  gen_ffs: for i in width-2 downto 0 generate
    ff_i: ff port map(clk, '0', q(i+1), q(i));
  end generate;
  
end;
