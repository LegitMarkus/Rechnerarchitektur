library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity serialadder is 
  generic(width: integer);
  port(clk, set: in std_ulogic;
       a, b:     in std_ulogic_vector(width-1 downto 0);
       cout :   out std_ulogic;
       sum:     out std_ulogic_vector(width-1 downto 0));
end;

architecture struct of serialadder is
  component ff
    port(clk, reset: in std_ulogic;
         d: in std_ulogic;
         q: out std_ulogic);
  end component;

  component shiftreg 
    generic(width: integer);
    port(clk: in std_ulogic;
         d:   in std_ulogic;
         q:  out std_ulogic_vector(width-1 downto 0));
  end component;

  component setableshiftreg
    generic(width: integer);
    port(clk, set: in std_ulogic;
         d:        in std_ulogic_vector(width-1 downto 0);
         q:       out std_ulogic);
  end component;

  component fa
    port(a,b,cin:  in std_ulogic;
         cout, s: out std_ulogic);
  end component;

  signal fa_a, fa_b, fa_sum, fa_cout: std_ulogic;
  
begin
    
    A_SR: setableshiftreg generic map(width) port map(clk, set, a, fa_a);
    
    B_SR: setableshiftreg generic map(width) port map(clk, set, b, fa_b);

    C_FF: ff port map(clk, set, fa_cout, cout);
    
    VA: fa port map(fa_a, fa_b, cout, fa_cout, fa_sum);
    
    S_SR: shiftreg generic map(width) port map(clk, fa_sum, sum);
    
end;
