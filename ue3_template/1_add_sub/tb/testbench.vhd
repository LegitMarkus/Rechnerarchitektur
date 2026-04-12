-- Testbench

library ieee; use ieee.std_logic_1164.all; use ieee.std_logic_unsigned.all; use ieee.numeric_std.all;

entity testbench is
end;

architecture test of testbench is
  component add_sub
    port(a, b:   in std_ulogic_vector(7 downto 0);
         sub:    in std_ulogic;
         result: out std_ulogic_vector(7 downto 0);
         overflow: out std_ulogic);
  end component;
  signal a, b:    std_ulogic_vector(7 downto 0);
  signal y:  std_ulogic_vector(7 downto 0);
  signal sub, overflow:	  std_ulogic;
begin
  my_add_sub: add_sub port map(a, b, sub, y, overflow);

  
  process
    variable result_ref : integer;
    variable overflow_ref : std_ulogic;
  begin

    sub <= '0';
    a <= std_ulogic_vector(to_signed(15, a'length));
    b <= std_ulogic_vector(to_signed(10, b'length));
    result_ref := 15+10;
    overflow_ref := '1' when (result_ref < -128) or (result_ref > 127) else '0';
    wait for 40 ns;
    report "15 + 10 = " & integer'image(to_integer(signed(y))) & " (OF:" & std_ulogic'image(overflow) & ") / ref: " & integer'image(result_ref) & " (OF:" & std_ulogic'image(overflow_ref) & ")";
    
    a <= std_ulogic_vector(to_signed(111, a'length));
    b <= std_ulogic_vector(to_signed(80, b'length));
    result_ref := 111+80;
    overflow_ref := '1' when (result_ref < -128) or (result_ref > 127) else '0';
    wait for 40 ns;
    report "111 + 80 = " & integer'image(to_integer(signed(y))) & " (OF:" & std_ulogic'image(overflow) & ") / ref: " & integer'image(result_ref) & " (OF:" & std_ulogic'image(overflow_ref) & ")";
    
    sub <= '1';
    a <= std_ulogic_vector(to_signed(19, a'length));
    b <= std_ulogic_vector(to_signed(46, b'length));
    result_ref := 19-46;
    overflow_ref := '1' when (result_ref < -128) or (result_ref > 127) else '0';
    wait for 40 ns;
    report "19 - 46 = " & integer'image(to_integer(signed(y))) & " (OF:" & std_ulogic'image(overflow) & ") / ref: " & integer'image(result_ref) & " (OF:" & std_ulogic'image(overflow_ref) & ")";

    a <= std_ulogic_vector(to_signed(-15, a'length));
    b <= std_ulogic_vector(to_signed(-10, b'length));
    result_ref := -15-(-10);
    overflow_ref := '1' when (result_ref < -128) or (result_ref > 127) else '0';
    wait for 40 ns;
    report "-15 - (-10) = " & integer'image(to_integer(signed(y))) & " (OF:" & std_ulogic'image(overflow) & ") / ref: " & integer'image(result_ref) & " (OF:" & std_ulogic'image(overflow_ref) & ")";

    a <= std_ulogic_vector(to_signed(-111, a'length));
    b <= std_ulogic_vector(to_signed(80, b'length));
    result_ref := -111-80;
    overflow_ref := '1' when (result_ref < -128) or (result_ref > 127) else '0';
    wait for 40 ns;
    report "-111 - 80 = " & integer'image(to_integer(signed(y))) & " (OF:" & std_ulogic'image(overflow) & ") / ref: " & integer'image(result_ref) & " (OF:" & std_ulogic'image(overflow_ref) & ")";

    report "-------------";

    for aa in -128 to 127 loop
      for bb in -128 to 127 loop
        sub <= '0';
        a <= std_ulogic_vector(to_signed(aa, a'length));
        b <= std_ulogic_vector(to_signed(bb, b'length));
        result_ref := aa+bb;
        overflow_ref := '1' when (result_ref < -128) or (result_ref > 127) else '0';
        wait for 5 ns;
        if (aa + bb <= 127) and (aa + bb >= -128) and (aa + bb /= to_integer(signed(y))) then
          report integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(signed(y))) & " (OF:" & std_ulogic'image(overflow) & ") / ref: " & integer'image(result_ref) & " (OF:" & std_ulogic'image(overflow_ref) & ")" severity error;                 
          wait;
        end if;
        assert overflow = overflow_ref
          report "Wrong overflow indication for " & integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(signed(y))) & " / ref: " & integer'image(result_ref) severity error;
        wait for 5 ns;
        sub <= '1';
        result_ref := aa-bb;
        overflow_ref := '1' when (result_ref < -128) or (result_ref > 127) else '0';
        wait for 5 ns;
        if (aa - bb <= 127) and (aa - bb >= -128) and (aa - bb /= to_integer(signed(y))) then
          report integer'image(aa) & " - " & integer'image(bb) & " = " & integer'image(to_integer(signed(y))) & " (OF:" & std_ulogic'image(overflow) & ") / ref: " & integer'image(result_ref) & " (OF:" & std_ulogic'image(overflow_ref) & ")" severity error; 
          wait; 
        end if;	
        assert overflow = overflow_ref
          report "Wrong overflow indication for " & integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(signed(y))) & " / ref: " & integer'image(result_ref) severity error;		
      end loop;
    end loop;
    report "No failure found.";
    wait;
  end process;
end;
