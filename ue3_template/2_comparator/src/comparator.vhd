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
architecture struct of fa is
begin
    cout <= (a and b) or (a and cin) or (b and cin);
    s <= a xor b xor cin;
end;

architecture struct of adder is
  component fa 
        port(a, b, cin: in std_ulogic;
            cout, s: out std_ulogic);
  end component;
  signal c0, c1, c2, c3, c4, c5, c6: std_ulogic;
begin
  fa0: fa port map(a(0), b(0), cin, c0, sum(0));
  fa1: fa port map(a(1), b(1), c0, c1, sum(1));
  fa2: fa port map(a(2), b(2), c1, c2, sum(2));
  fa3: fa port map(a(3), b(3), c2, c3, sum(3));
  fa4: fa port map(a(4), b(4), c3, c4, sum(4));
  fa5: fa port map(a(5), b(5), c4, c5, sum(5));
  fa6: fa port map(a(6), b(6), c5, c6, sum(6));
  fa7: fa port map(a(7), b(7), c6, cout, sum(7));
end;

architecture struct of comparator is
  component adder is
    port(a,b:  in std_ulogic_vector(7 downto 0);
        cin:  in std_ulogic;
        cout: out std_ulogic;
        sum:  out std_ulogic_vector(7 downto 0));
  end component;

  signal b_inv: std_ulogic_vector(7 downto 0);
  signal diff: std_ulogic_vector(7 downto 0);
  signal cout: std_ulogic;
  signal or01, or23, or45, or67: std_ulogic;
  signal or0123, or4567: std_ulogic;
  signal or012345678: std_ulogic;
begin
  b_inv <= not b;
  sub0: adder port map(a => a, b => b_inv, cin => '1', cout => cout, sum => diff);

  or01 <= diff(0) or diff(1);
  or23 <= diff(2) or diff(3);
  or45 <= diff(4) or diff(5);
  or67 <= diff(6) or diff(7);
  or0123 <= or01 or or23;
  or4567 <= or45 or or67;
  or012345678 <= or0123 or or4567;

  result(0) <= not cout;
  result(1) <= cout and or012345678;
end;
