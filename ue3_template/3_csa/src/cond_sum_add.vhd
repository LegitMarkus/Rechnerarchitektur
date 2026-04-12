library ieee; use ieee.std_logic_1164.all;
entity adder is
  port(a,b:  in std_ulogic_vector(15 downto 0);
       cin:  in std_ulogic;
       cout: out std_ulogic;
       sum:  out std_ulogic_vector(15 downto 0));
end;

--TODO implement conditional sum adder
