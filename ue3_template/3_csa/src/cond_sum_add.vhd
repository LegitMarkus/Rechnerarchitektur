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
entity mux2 is
  port(
    a, b: in  std_ulogic;
    sel: in  std_ulogic;
    s: out std_ulogic
  );
end entity;

library ieee; use ieee.std_logic_1164.all;
entity csa is
  generic(
    n : integer := 16
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

architecture struct of mux2 is
begin
  s <= (a and (not sel)) or (b and sel);
end architecture;

architecture struct of csa is
  constant half_width : integer := n / 2;
  signal carry_low : std_ulogic;
  signal sum_high_if0   : std_ulogic_vector(half_width-1 downto 0);
  signal sum_high_if1   : std_ulogic_vector(half_width-1 downto 0);
  signal carry_high_if0 : std_ulogic;
  signal carry_high_if1 : std_ulogic;
begin
  base_case : if n = 1 generate
    fa_0 : entity work.fa
      port map(
        a    => a(0),
        b    => b(0),
        cin  => cin,
        cout => cout,
        s    => sum(0)
      );
  end generate;

  rec_case : if n > 1 generate
    low_part : entity work.csa
      generic map(n => half_width)
      port map(
        a    => a(half_width-1 downto 0),
        b    => b(half_width-1 downto 0),
        cin  => cin,
        cout => carry_low,
        sum  => sum(half_width-1 downto 0)
      );

    high_part0 : entity work.csa
      generic map(n => half_width)
      port map(
        a    => a(n-1 downto half_width),
        b    => b(n-1 downto half_width),
        cin  => '0',
        cout => carry_high_if0,
        sum  => sum_high_if0
      );

    high_part1 : entity work.csa
      generic map(n => half_width)
      port map(
        a    => a(n-1 downto half_width),
        b    => b(n-1 downto half_width),
        cin  => '1',
        cout => carry_high_if1,
        sum  => sum_high_if1
      );

    mux_sum : for i in 0 to half_width-1 generate
      m : entity work.mux2
        port map(
          a   => sum_high_if0(i),
          b   => sum_high_if1(i),
          sel => carry_low,
          s   => sum(half_width+i)
        );
    end generate;

    mux_cout : entity work.mux2
      port map(
        a   => carry_high_if0,
        b   => carry_high_if1,
        sel => carry_low,
        s   => cout
      );
  end generate;
end architecture;

architecture struct of adder is
begin
  top : entity work.csa
    generic map(n => 16)
    port map(
      a    => a,
      b    => b,
      cin  => cin,
      cout => cout,
      sum  => sum
    );
end architecture;