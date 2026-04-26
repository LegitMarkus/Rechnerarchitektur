library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity mult is 
  port(a:   in STD_ULOGIC_VECTOR(15 downto 0);
       b:   in STD_ULOGIC_VECTOR(15 downto 0);
       y:   out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture struct of mult is 
  component adder is 
    generic(width: integer := 32);
    port(a, b: in std_ulogic_vector(width-1 downto 0);
    cin: in std_ulogic;
    cout: out std_ulogic;
    sum: out std_ulogic_vector(width-1 downto 0));
  end component;
  --Partialprodukte (Ebene 0)
  signal pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8, pp9, pp10, pp11, pp12, pp13, pp14, pp15: std_ulogic_vector(31 downto 0);

  --Ebene 1 Variablen
  signal s10, s11, s12, s13, s14, s15, s16, s17: std_ulogic_vector(31 downto 0);
  signal c10, c11, c12, c13, c14, c15, c16, c17: std_ulogic;
  --Ebene 2 Variablen
  signal s20, s21, s22, s23: std_ulogic_vector(31 downto 0);
  signal c20, c21, c22, c23: std_ulogic;
  --Ebene 3 Variablen
  signal s30, s31: std_ulogic_vector(31 downto 0);
  signal c30, c31: std_ulogic;
  --Ebene 4 Variablen
  signal c40: std_ulogic;

begin
    --TODO
    pp0 <= (31 downto 16 => '0') & (a and (15 downto 0 => b(0)));
    pp1 <= (31 downto 17 => '0') & (a and (15 downto 0 => b(1))) & (0 downto 0 => '0');
    pp2 <= (31 downto 18 => '0') & (a and (15 downto 0 => b(2))) & (1 downto 0 => '0');
    pp3 <= (31 downto 19 => '0') & (a and (15 downto 0 => b(3))) & (2 downto 0 => '0');
    pp4 <= (31 downto 20 => '0') & (a and (15 downto 0 => b(4))) & (3 downto 0 => '0');
    pp5 <= (31 downto 21 => '0') & (a and (15 downto 0 => b(5))) & (4 downto 0 => '0');
    pp6 <= (31 downto 22 => '0') & (a and (15 downto 0 => b(6))) & (5 downto 0 => '0');
    pp7 <= (31 downto 23 => '0') & (a and (15 downto 0 => b(7))) & (6 downto 0 => '0');
    pp8 <= (31 downto 24 => '0') & (a and (15 downto 0 => b(8))) & (7 downto 0 => '0');
    pp9 <= (31 downto 25 => '0') & (a and (15 downto 0 => b(9))) & (8 downto 0 => '0');
    pp10 <= (31 downto 26 => '0') & (a and (15 downto 0 => b(10))) & (9 downto 0 => '0');
    pp11 <= (31 downto 27 => '0') & (a and (15 downto 0 => b(11))) & (10 downto 0 => '0');
    pp12 <= (31 downto 28 => '0') & (a and (15 downto 0 => b(12))) & (11 downto 0 => '0');
    pp13 <= (31 downto 29 => '0') & (a and (15 downto 0 => b(13))) & (12 downto 0 => '0');
    pp14 <= (31 downto 30 => '0') & (a and (15 downto 0 => b(14))) & (13 downto 0 => '0');
    pp15 <= (31 downto 31 => '0') & (a and (15 downto 0 => b(15))) & (14 downto 0 => '0');

    --Zusammenadden Ebene 1
    a10: adder generic map(32) port map(pp0, pp1, '0', c10, s10);
    a11: adder generic map(32) port map(pp2, pp3, '0', c11, s11);
    a12: adder generic map(32) port map(pp4, pp5, '0', c12, s12);
    a13: adder generic map(32) port map(pp6, pp7, '0', c13, s13);
    a14: adder generic map(32) port map(pp8, pp9, '0', c14, s14);
    a15: adder generic map(32) port map(pp10, pp11, '0', c15, s15);
    a16: adder generic map(32) port map(pp12, pp13, '0', c16, s16);
    a17: adder generic map(32) port map(pp14, pp15, '0', c17, s17);
    --Zusammenadden Ebene 2
    a20: adder generic map(32) port map(s10, s11, '0', c20, s20);
    a21: adder generic map(32) port map(s12, s13, '0', c21, s21);
    a22: adder generic map(32) port map(s14, s15, '0', c22, s22);
    a23: adder generic map(32) port map(s16, s17, '0', c23, s23);
    --Zusammenadden Ebene 3
    a30: adder generic map(32) port map(s20, s21, '0', c30, s30);
    a31: adder generic map(32) port map(s22, s23, '0', c31, s31);
    --Zusammenadden Ebene 4
    a40: adder generic map(32) port map(s30, s31, '0', c40, y);

end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity fa is
    port(a, b, cin: in std_ulogic;
         cout, s:  out std_ulogic);
end;

architecture struct of fa is
begin
    cout <= (a and b) or (a and cin) or (b and cin);
    s <= a xor b xor cin;
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity adder is 
  generic(width: integer := 32);
  port(a, b: in std_ulogic_vector(width-1 downto 0);
  cin: in std_ulogic;
  cout: out std_ulogic;
  sum: out std_ulogic_vector(width-1 downto 0));
end;

architecture struct of adder is
  component fa is
    port(a, b, cin: in std_ulogic;
         cout, s:  out std_ulogic);
  end component;

  signal c: std_ulogic_vector(width downto 0);
begin
  c(0) <= cin;
  gen_fa: for i in 0 to width-1 generate
    fa_i: fa port map(a(i), b(i), c(i), c(i+1), sum(i));
  end generate;

  cout <= c(width);
end;