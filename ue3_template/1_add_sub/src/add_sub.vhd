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
       result: out std_ulogic_vector(7 downto 0);
       overflow: out std_ulogic);
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
  signal c0, c1, c2, c3, c4, c5, c6, c7: std_ulogic;
begin
  fa0: fa port map(a(0), b(0), cin, c0, sum(0));
  fa1: fa port map(a(1), b(1), c0, c1, sum(1));
  fa2: fa port map(a(2), b(2), c1, c2, sum(2));
  fa3: fa port map(a(3), b(3), c2, c3, sum(3));
  fa4: fa port map(a(4), b(4), c3, c4, sum(4));
  fa5: fa port map(a(5), b(5), c4, c5, sum(5));
  fa6: fa port map(a(6), b(6), c5, c6, sum(6));
  fa7: fa port map(a(7), b(7), c6, c7, sum(7));

  cout <= c7;
  overflow <= c6 xor c7;
end;

architecture struct of add_sub is
  component adder is
    port(a,b:  in std_ulogic_vector(7 downto 0);
        cin:  in std_ulogic;
        cout: out std_ulogic;
        overflow: out std_ulogic;
        sum:  out std_ulogic_vector(7 downto 0));
  end component;
  signal bx: std_ulogic_vector(7 downto 0);
  signal cout: std_ulogic;
begin
  bx <= b xor (7 downto 0 => sub);
  
  a0: adder port map(
    a => a,
    b => bx,
    cin => sub,
    cout => cout,
    overflow => overflow,
    sum => result
  );
end;


