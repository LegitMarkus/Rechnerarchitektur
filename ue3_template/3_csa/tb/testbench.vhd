-- Testbench

library ieee; use ieee.std_logic_1164.all; use ieee.std_logic_unsigned.all; use ieee.numeric_std.all;

entity testbench is
end;

architecture test of testbench is
  component adder
    port(a, b: in std_ulogic_vector(15 downto 0);
         cin:  in std_ulogic;
         cout: out std_ulogic;
         sum:  out std_ulogic_vector(15 downto 0));
  end component;
  signal a, b:   std_ulogic_vector(15 downto 0);
  signal y:      std_ulogic_vector(16 downto 0);   
begin
  my_add: adder port map(a, b, '0', y(16), y(15 downto 0));
  
  process begin
      a <= std_ulogic_vector(to_unsigned(15, a'length));
      b <= std_ulogic_vector(to_unsigned(10, b'length));
      wait for 40 ns;
      report "15 + 10 = " & integer'image(to_integer(unsigned(y)));

      a <= std_ulogic_vector(to_unsigned(11, a'length));
      b <= std_ulogic_vector(to_unsigned(2, b'length));
      wait for 40 ns;
      report "11 + 2 = " & integer'image(to_integer(unsigned(y)));

      a <= std_ulogic_vector(to_unsigned(19, a'length));
      b <= std_ulogic_vector(to_unsigned(46, b'length));
      wait for 40 ns;
      report "19 + 46 = " & integer'image(to_integer(unsigned(y)));

      report "---------------";
      
      for aa in 65280 to 65535 loop
        for bb in 65280 to 65535 loop
          a <= std_ulogic_vector(to_unsigned(aa, a'length));
          b <= std_ulogic_vector(to_unsigned(bb, b'length));			
          wait for 5 ns;
          if (aa + bb /= to_integer(unsigned(y))) then
            report integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(unsigned(y))) severity error; 
            wait;
          end if;
        end loop;
      end loop;
      report "No failure found.";
      wait;
  end process;
end;
