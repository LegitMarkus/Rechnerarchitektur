library ieee; use ieee.std_logic_1164.all;
entity adder is
  port(a,b:  in std_ulogic_vector(15 downto 0);
       cin:  in std_ulogic;
       cout: out std_ulogic;
       sum:  out std_ulogic_vector(15 downto 0));
end;

--TODO implement conditional sum adder
library ieee; use ieee.std_logic_1164.all;
entity fa is
  port(
    a, b, cin : in  std_ulogic;
    cout, s: out std_ulogic
  );
end entity;

library ieee; use ieee.std_logic_1164.all;
entity mux2_gen is
  generic(width : integer := 2);
  port(a, b: in  std_ulogic_vector(width-1 downto 0);
       s:    in  std_ulogic;
       y:    out std_ulogic_vector(width-1 downto 0));
end entity;

library ieee; use ieee.std_logic_1164.all;
entity csa is
  generic(
    n: integer := 16
  );
  port(
    a, b: in std_ulogic_vector(n-1 downto 0);
    cin: in std_ulogic;
    cout: out std_ulogic;
    sum: out std_ulogic_vector(n-1 downto 0)
  );
end entity;

architecture struct of fa is
begin
  cout <= (a and b) or (a and cin) or (b and cin);
  s    <= a xor b xor cin;
end architecture;

architecture struct of mux2_gen is
begin
  y <= (a and (not (width-1 downto 0 => s))) or (b and (width-1 downto 0 => s));
end architecture;

architecture struct of csa is
  component fa
    port(
      a, b, cin : in  std_ulogic;
      cout, s: out std_ulogic
    );
  end component;

  component mux2_gen
    generic(width : integer := 2);
    port(a, b: in  std_ulogic_vector(width-1 downto 0);
         s:    in  std_ulogic;
         y:    out std_ulogic_vector(width-1 downto 0));
  end component;

  component csa
    generic(
      n : integer := 16
    );
    port(
      a, b: in std_ulogic_vector(n-1 downto 0);
      cin: in std_ulogic;
      cout: out std_ulogic;
      sum: out std_ulogic_vector(n-1 downto 0)
    );
  end component;

  constant half_width: integer := n / 2;

  signal carry_low: std_ulogic;
  
  signal sum_high_if0: std_ulogic_vector(half_width-1 downto 0);
  signal sum_high_if1: std_ulogic_vector(half_width-1 downto 0);
  signal carry_high_if0: std_ulogic;
  signal carry_high_if1: std_ulogic;

  signal upper_if0: std_ulogic_vector(half_width downto 0);
  signal upper_if1: std_ulogic_vector(half_width downto 0);
  signal upper_selected: std_ulogic_vector(half_width downto 0);
begin
  base_case: if n = 1 generate
    fa_0: fa
      port map(
        a => a(0),
        b => b(0),
        cin => cin,
        cout => cout,
        s => sum(0)
      );
  end generate;

  rec_case: if n > 1 generate
    low_part: csa
      generic map(n => half_width)
      port map(
        a => a(half_width-1 downto 0),
        b => b(half_width-1 downto 0),
        cin => cin,
        cout => carry_low,
        sum => sum(half_width-1 downto 0)
      );

    high_part0: csa
      generic map(n => half_width)
      port map(
        a => a(n-1 downto half_width),
        b => b(n-1 downto half_width),
        cin => '0',
        cout => carry_high_if0,
        sum => sum_high_if0
      );

    high_part1: csa
      generic map(n => half_width)
      port map(
        a => a(n-1 downto half_width),
        b => b(n-1 downto half_width),
        cin => '1',
        cout => carry_high_if1,
        sum => sum_high_if1
      );
    --& hängt zwa kabeln zaum
    upper_if0 <= carry_high_if0 & sum_high_if0;
    upper_if1 <= carry_high_if1 & sum_high_if1;

    mux_upper: mux2_gen
      generic map(width => half_width + 1)
      port map(
        a => upper_if0,
        b => upper_if1,
        s => carry_low,
        y => upper_selected
      );

    cout <= upper_selected(half_width);
    sum(n-1 downto half_width) <= upper_selected(half_width-1 downto 0);
  end generate;
end architecture;

architecture struct of adder is
  component csa
    generic(
      n: integer := 16
    );
    port(
      a, b: in std_ulogic_vector(n-1 downto 0);
      cin: in std_ulogic;
      cout: out std_ulogic;
      sum: out std_ulogic_vector(n-1 downto 0)
    );
  end component;
begin
  top: csa generic map(n => 16)
    port map(
      a    => a,
      b    => b,
      cin  => cin,
      cout => cout,
      sum  => sum
    );
end architecture;