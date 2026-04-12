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
    cout, s   : out std_ulogic
  );
end entity;

architecture struct of fa is
begin
  s    <= a xor b xor cin;
  cout <= (a and b) or (a and cin) or (b and cin);
end architecture;


library ieee; use ieee.std_logic_1164.all;
entity mux2 is
  port(
    d0, d1 : in  std_ulogic;
    sel    : in  std_ulogic;
    y      : out std_ulogic
  );
end entity;

architecture struct of mux2 is
begin
  y <= (d0 and (not sel)) or (d1 and sel);
end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity csa is
  generic(
    n : positive := 16
  );
  port(
    a, b : in  std_ulogic_vector(n-1 downto 0);
    cin  : in  std_ulogic;
    cout : out std_ulogic;
    sum  : out std_ulogic_vector(n-1 downto 0)
  );
end entity;

architecture struct of csa is
  component fa
    port(
      a, b, cin : in  std_ulogic;
      cout, s   : out std_ulogic
    );
  end component;

  component mux2
    port(
      d0, d1 : in  std_ulogic;
      sel    : in  std_ulogic;
      y      : out std_ulogic
    );
  end component;

  component csa
    generic(
      n : positive
    );
    port(
      a, b : in  std_ulogic_vector(n-1 downto 0);
      cin  : in  std_ulogic;
      cout : out std_ulogic;
      sum  : out std_ulogic_vector(n-1 downto 0)
    );
  end component;

  constant h : positive := n / 2;

  signal c_low : std_ulogic;

  signal sum_hi0 : std_ulogic_vector(h-1 downto 0);
  signal sum_hi1 : std_ulogic_vector(h-1 downto 0);
  signal c_hi0   : std_ulogic;
  signal c_hi1   : std_ulogic;

begin
  base_case : if n = 1 generate
    fa_0 : fa port map(
      a    => a(0),
      b    => b(0),
      cin  => cin,
      cout => cout,
      s    => sum(0)
    );
  end generate;

  rec_case : if n > 1 generate
    low_part : csa
      generic map(n => h)
      port map(
        a    => a(h-1 downto 0),
        b    => b(h-1 downto 0),
        cin  => cin,
        cout => c_low,
        sum  => sum(h-1 downto 0)
      );

    high_part0 : csa
      generic map(n => h)
      port map(
        a    => a(n-1 downto h),
        b    => b(n-1 downto h),
        cin  => '0',
        cout => c_hi0,
        sum  => sum_hi0
      );

    high_part1 : csa
      generic map(n => h)
      port map(
        a    => a(n-1 downto h),
        b    => b(n-1 downto h),
        cin  => '1',
        cout => c_hi1,
        sum  => sum_hi1
      );

    mux_sum : for i in 0 to h-1 generate
      m : mux2 port map(
        d0  => sum_hi0(i),
        d1  => sum_hi1(i),
        sel => c_low,
        y   => sum(h+i)
      );
    end generate;

    mux_cout : mux2 port map(
      d0  => c_hi0,
      d1  => c_hi1,
      sel => c_low,
      y   => cout
    );
  end generate;
end architecture;

architecture struct of adder is
  component csa
    generic(
      n : positive
    );
    port(
      a, b : in  std_ulogic_vector(n-1 downto 0);
      cin  : in  std_ulogic;
      cout : out std_ulogic;
      sum  : out std_ulogic_vector(n-1 downto 0)
    );
  end component;
begin
  top : csa
    generic map(n => 16)
    port map(
      a    => a,
      b    => b,
      cin  => cin,
      cout => cout,
      sum  => sum
    );
end architecture;