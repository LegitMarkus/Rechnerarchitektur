-- generic counter based on adder and register
library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity countdown is
  generic (width: integer);
  port(clk, reset: in  std_ulogic;
       y:          out std_ulogic_vector(width-1 downto 0);
       alarm:      out std_ulogic);
end;    

architecture struct of countdown is
  
begin

end;









