library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all; 
use IEEE.NUMERIC_STD.all;

entity testbench is
end;

architecture test of testbench is

  component countdown is
    generic(width: integer);
    port(clk, reset: in  std_ulogic;
         y:          out std_ulogic_vector(width-1 downto 0);
         alarm:      out std_ulogic);
  end component;

  constant w_a: integer := 3;
  constant w_b: integer := 4;  
    
  signal clk, reset: std_ulogic := '0';
  signal y_a:        std_ulogic_vector(w_a-1 downto 0);
  signal y_b:        std_ulogic_vector(w_b-1 downto 0);
  signal alarm_a:    std_ulogic;
  signal alarm_b:    std_ulogic;
  
begin
  -- initiate device to be tested
  four: countdown generic map(width => w_a) port map(clk, reset, y_a, alarm_a);
  five: countdown generic map(width => w_b) port map(clk, reset, y_b, alarm_b);
  
  -- generate clock with 10 ns period
  process
    variable a_ref : integer := 2**w_a-1;
    variable b_ref : integer := 2**w_b-1;
    variable alarm_a_ref, alarm_b_ref : std_ulogic := '0';
  begin
    
      for i in 1 to 35 loop
        clk <= not(clk);
        wait for 5 ps;
        clk <= not(clk);
        wait for 5 ps;
       
        report " y_a=" & integer'image(to_integer(unsigned(y_a))) & ", alarm = " & std_ulogic'image((alarm_a)) & "   |  y_b=" & integer'image(to_integer(unsigned(y_b))) & ", alarm = " & std_ulogic'image((alarm_b));
        assert to_integer(unsigned(y_a)) = a_ref report "Output for " & integer'image(w_a) & " bit width wrong: " & integer'image(to_integer(unsigned(y_a))) & " (should be " & integer'image(a_ref) & ")" severity failure;
        assert to_integer(unsigned(y_b)) = b_ref report "Output for " & integer'image(w_b) & " bit width wrong: " & integer'image(to_integer(unsigned(y_b))) & " (should be " & integer'image(b_ref) & ")" severity failure;
        assert alarm_a = alarm_a_ref report "Alarm for " & integer'image(w_a) & " is not triggered right: " & std_ulogic'image(alarm_a) & " (should be " & std_ulogic'image(alarm_a_ref) & ")" severity failure;
        assert alarm_b = alarm_b_ref report "Alarm for " & integer'image(w_b) & " is not triggered right: " & std_ulogic'image(alarm_b) & " (should be " & std_ulogic'image(alarm_b_ref) & ")" severity failure;
        if reset = '0' then
          if a_ref = 0 then
            a_ref := 2**w_a-1;
            alarm_a_ref := '1';
          else
            a_ref := a_ref - 1;
            alarm_a_ref := '0';
          end if;
          if b_ref = 0 then
            b_ref := 2**w_b-1;
            alarm_b_ref := '1';
          else
            b_ref := b_ref - 1;
            alarm_b_ref := '0';
          end if;
        end if;
      end loop;
      report "No failure found!";
      wait;
    end process;

    process begin
      report("reset");
      reset <= '1';
      wait for 24 ps;
      reset <= '0';
      report("reset released");
      wait;
   end process;
end;
