library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench is
end;


architecture bhv of testbench is
  component MUX2
    port(a, b: in  std_ulogic;
         s:    in  std_ulogic; 
         y:    out std_ulogic);
  end component;


  component MUX2_gen is
  generic(width : integer := 2);
  port(a, b: in  std_ulogic_vector(width-1 downto 0);
       s:    in  std_ulogic; 
       y:    out std_ulogic_vector(width-1 downto 0));
  end component;

  signal a, b, s, y : std_ulogic;
  
  constant width : integer := 8;
  signal a2, b2, y2 : std_ulogic_vector(width-1 downto 0); 
  signal s2 : std_ulogic;
begin
  mux2_inst: mux2 port map ( a, b, s, y );
  
  mux2_gen_inst: mux2_gen generic map (width) port map ( a2, b2, s2, y2 );

  process
    begin
      a <= '0';
      b <= '1';
      s <= '0';
      wait for 5 ns;
      report "I: a = " & std_ulogic'image(a) & "; b = " & std_logic'image(b) & "; s = " & std_logic'image(s);
      report "O: y = " & std_ulogic'image(y);

      s <= '1';
      wait for 5 ns;
      report "I: a = " & std_ulogic'image(a) & "; b = " & std_logic'image(b) & "; s = " & std_logic'image(s);
      report "O: y = " & std_ulogic'image(y);

      
      a2 <= (others => '0');
      b2 <= (others => '1');
      s2 <= '0';
      wait for 5 ns;
      report "I: a = " & integer'image(to_integer(unsigned(a2))) & "; b = " & integer'image(to_integer(unsigned(b2))) & "; s = " & std_logic'image(s2);
      report "O: y = " & integer'image(to_integer(unsigned(y2)));

      s2 <= '1';
      wait for 5 ns;
      report "I: a = " & integer'image(to_integer(unsigned(a2))) & "; b = " & integer'image(to_integer(unsigned(b2))) & "; s = " & std_logic'image(s2);
      report "O: y = " & integer'image(to_integer(unsigned(y2)));
      
      wait;     
    end process;
end;
