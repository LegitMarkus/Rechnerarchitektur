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
       overflow: out std_ulogic;
       sum:  out std_ulogic_vector(7 downto 0));
end;

library ieee; use ieee.std_logic_1164.all;
entity add_sub is
  port(a, b: in std_ulogic_vector(7 downto 0);
       sub: in std_ulogic;
       result: out std_ulogic_vector(7 downto 0)
       overflow: out std_ulogic);
end;



--TODO implement architectures



