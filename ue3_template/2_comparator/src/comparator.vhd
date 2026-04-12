library ieee; use ieee.std_logic_1164.all;
entity fa is
  port(a,b,cin: in std_ulogic;
       cout, s: out std_ulogic);
end;

library ieee; use ieee.std_logic_1164.all;
entity adder is
  port(a,b:  in std_ulogic_vector(7 downto 0);
       cin:  in std_ulogic;
       cout: out std_ulogic;
       sum:  out std_ulogic_vector(7 downto 0));
end;

library ieee; use ieee.std_logic_1164.all;
entity comparator is
  port(a, b: in std_ulogic_vector(7 downto 0);
       result: out std_ulogic_vector(1 downto 0));
end;



--TODO implement architectures
