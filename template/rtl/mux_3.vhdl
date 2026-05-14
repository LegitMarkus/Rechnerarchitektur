library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_3 is -- three-input multiplexer
  port(d0:  in  STD_ULOGIC_VECTOR(31 downto 0);
       d1:  in  STD_ULOGIC_VECTOR(31 downto 0);
       d2:  in  STD_ULOGIC_VECTOR(31 downto 0);
       s:   in  STD_ULOGIC_VECTOR(1 downto 0);
       y:   out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture bhv of mux_3 is
begin
  process(d0, d1, d2, s) begin
    if    (s = "00") then y <= d0;
    elsif (s = "01") then y <= d1;
    elsif (s = "10") then y <= d2;
    else y <= (others => '0');
    end if;
  end process;
end;
