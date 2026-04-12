library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench is
end;


architecture bhv of testbench is
  component cra
    port(a, b: in  std_ulogic_vector(3 downto 0);
         cin:  in  std_ulogic;
         cout: out std_ulogic;
         sum:  out std_ulogic_vector(3 downto 0));
  end component;
  component cra_gen
    generic(width: integer);
        port(a, b: in  std_ulogic_vector(width-1 downto 0);
            cin:   in  std_ulogic;
            cout:  out std_ulogic;
            sum:   out std_ulogic_vector(width-1 downto 0));
  end component;
  
  constant width : integer := 4;
  signal a, b: std_ulogic_vector(3 downto 0);
  signal y:    std_ulogic_vector(4 downto 0);
  
begin
    cra_comp: cra port map(a, b, '0', y(4), y(3 downto 0));
--    cra_comp: cra_gen generic map(4) port map(a, b, '0', y(4), y(3 downto 0));

    process begin
        report "-- TRIAL CHECKS --";
        a <= std_ulogic_vector(to_unsigned(5, a'length));
        b <= std_ulogic_vector(to_unsigned(2, b'length));
        wait for 40 ns;
        report "5 + 2 = " & integer'image(to_integer(unsigned(y)));

        a <= std_ulogic_vector(to_unsigned(1, a'length));
        b <= std_ulogic_vector(to_unsigned(11, b'length));
        wait for 40 ns;
        report "1 + 11 = " & integer'image(to_integer(unsigned(y)));
        
        a <= STD_ULOGIC_VECTOR(to_unsigned(7, a'length));
        b <= STD_ULOGIC_VECTOR(to_unsigned(7, b'length));
        wait for 40 ns;
        report "7 + 7 = " & integer'image(to_integer(unsigned(y)));

        report "-- ERROR CHECKS --";
        for aa in 0 to 15 loop
            for bb in 0 to 15 loop
                a <= std_ulogic_vector(to_unsigned(aa, a'length));
                b <= std_ulogic_vector(to_unsigned(bb, b'length));
                wait for 5 ns;
                if(aa+bb /= to_integer(unsigned(y))) then
                    report integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(unsigned(y))) severity error;
                    wait;
                end if;
            end loop;
        end loop;
        report "all done";
        wait;
    end process;
end;
