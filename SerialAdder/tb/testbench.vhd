library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED; 
use IEEE.numeric_std.all;

entity testbench is
end;

architecture test of testbench is
  
  component serialadder
    generic(width: integer);
    port(clk, set: in std_ulogic;
         a, b: in std_ulogic_vector(7 downto 0);
         cout: out std_ulogic;
         sum: out std_ulogic_vector(7 downto 0));
  end component;
  
  signal clk, reset: std_ulogic := '0';
  signal a, b:       std_ulogic_vector(7 downto 0);
  signal sum:        std_ulogic_vector(8 downto 0);
  signal run:        std_ulogic := '1';
  
begin
  -- initiate device to be tested
  dut: serialadder generic map(width => 8) port map(clk, reset, a, b, sum(8), sum(7 downto 0));

  -- generate clock with 10 ns period
  process begin
    while run /= '0' loop
      clk <= '1';
      wait for 5 ps;
      clk <= '0';
      wait for 5 ps;
    end loop;
    wait;
  end process;

    -- test several combinations
  process is
    variable aa, bb, tests, failed: Integer;
  begin
    aa := 0;
    tests := 0;
    failed := 0;
    while (aa <= 255) loop
      bb := 0;
      while (bb <= 255) loop
        a <= std_ulogic_VECTOR(TO_UNSIGNED(aa, a'length));
        b <= std_ulogic_VECTOR(TO_UNSIGNED(bb, b'length));
        reset <= '1';			
        wait for 20 ps;
        reset <= '0';
        wait for 80 ps;
        if (aa + bb /= to_integer(unsigned(sum))) then
          report integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(unsigned(sum))) severity error; 
          failed := failed + 1;
        end if;
        bb := bb + 5;
        tests := tests + 1;
      end loop;
      aa := aa + 5;
    end loop;
    run <= '0';
    report integer'image(failed) & " out of " & integer'image(tests) & " tests failed.";
    wait;
  end process;
  
end;
