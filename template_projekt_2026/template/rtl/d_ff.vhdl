library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity d_ff is
  port(clk, reset : in  STD_ULOGIC;
       reset_value: in  STD_ULOGIC_VECTOR(31 downto 0);
       d          : in  STD_ULOGIC_VECTOR(31 downto 0);
       q          : out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture bhv of d_ff is
begin
  process(clk, reset) begin
    if    reset = '1'       then q <= reset_value;
    elsif rising_edge(clk)  then q <= d;
    end if;
  end process;
end;