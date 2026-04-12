-- Testbench

library ieee; use ieee.std_logic_1164.all; use ieee.std_logic_unsigned.all; use ieee.numeric_std.all;

entity testbench is
end;

architecture test of testbench is
  component comparator
    port(a, b:   in std_ulogic_vector(7 downto 0);
         result: out std_ulogic_vector(1 downto 0));
  end component;
  signal a, b:    std_ulogic_vector(7 downto 0);
  signal y:  std_ulogic_vector(1 downto 0);
begin
  my_comparator: comparator port map(a, b, y);
  
  process begin
    a <= std_ulogic_vector(to_unsigned(15, a'length));
    b <= std_ulogic_vector(to_unsigned(15, b'length));
    wait for 5 ns;
    report "comp(15, 15) = " & integer'image(to_integer(unsigned(y)));
    
    a <= std_ulogic_vector(to_unsigned(3, a'length));
    b <= std_ulogic_vector(to_unsigned(15, b'length));
    wait for 5 ns;
    report "comp(3, 15) = " & integer'image(to_integer(unsigned(y))); 

    a <= std_ulogic_vector(to_unsigned(15, a'length));
    b <= std_ulogic_vector(to_unsigned(3, b'length));
    wait for 5 ns;
    report "comp(15, 3) = " & integer'image(to_integer(unsigned(y))); 

    report "-----------------";
    
    for aa in 0 to 127 loop
      for bb in 0 to 127 loop
        a <= std_ulogic_vector(to_unsigned(aa, a'length));
        b <= std_ulogic_vector(to_unsigned(bb, b'length));			
        wait for 5 ns;
        if (aa = bb) and (y /= "00") then 
          report "comp(" & integer'image(aa) & ", " & integer'image(bb) & ") = " & integer'image(to_integer(unsigned(y))) & ", should be 0" severity error; 
          wait;
        elsif (aa < bb) and (y /= "01") then 
          report "comp(" & integer'image(aa) & ", " & integer'image(bb) & ") = " & integer'image(to_integer(unsigned(y))) & ", should be 1" severity error; 
          wait;
        elsif (aa > bb ) and (y /= "10") then
          report "comp(" & integer'image(aa) & ", " & integer'image(bb) & ") = " & integer'image(to_integer(unsigned(y))) & ", should be 2" severity error; 
          wait;
        end if;
        wait for 5 ns;
      end loop;
    end loop;
    report "No failure found.";
    wait;
  end process;
end;
