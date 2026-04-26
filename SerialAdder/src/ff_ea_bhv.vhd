library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ff is
  port (clk, reset: in std_ulogic;
        d:          in std_ulogic;
        q:         out std_ulogic);
end;

architecture bhv of ff is
  
begin
  
    process(clk, reset)
    begin
        if reset = '1' then
            q <= '0';
        elsif clk'event and clk = '1' then
            q <= d;
        end if;
    end process;
    
end;
