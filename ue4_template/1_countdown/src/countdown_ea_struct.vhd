-- generic counter based on adder and register
library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity countdown is
  generic (width: integer);
  port(clk, reset: in  std_ulogic;
       y:          out std_ulogic_vector(width-1 downto 0);
       alarm:      out std_ulogic);
end;    

architecture struct of countdown is
  component ff is
  generic(width: integer;
          reset_val: std_ulogic_vector(width-1 downto 0));
  port(clk, reset: in std_ulogic;
       d:          in std_ulogic_vector(width-1 downto 0);
       q:         out std_ulogic_vector(width-1 downto 0));
  end component;

  component ff_single is
  generic(reset_val: std_ulogic);
  port(clk, reset: in std_ulogic;
       d:          in std_ulogic;
       q:         out std_ulogic);
  end component;

  signal curr_y: std_ulogic_vector(width-1 downto 0);
  signal next_y: std_ulogic_vector(width-1 downto 0);
  signal borrow: std_ulogic_vector(width-1 downto 0);
  signal or_chain: std_ulogic_vector(width-1 downto 0);
  signal zero_now: std_ulogic;
begin
  var_y: ff generic map (width => width, reset_val => (width-1 downto 0 => '1'))
        port map(clk => clk, reset => reset, d => next_y, q => curr_y);

  var_alarm: ff_single generic map (reset_val => '0')
                   port map (clk => clk, reset => reset, d => zero_now, q => alarm);

  y <= curr_y;
  borrow(0) <= '1';
  next_y(0) <= not curr_y(0);

  gen_sub: for i in 1 to width-1 generate
    borrow(i) <= borrow(i-1) and (not curr_y(i-1));
    next_y(i) <= curr_y(i) xor borrow(i);
    end generate;

  or_chain(0) <= curr_y(0);
  gen_or: for i in 1 to width-1 generate
      or_chain(i) <= or_chain(i-1) or curr_y(i);
    end generate;

    zero_now <= not or_chain(width-1);
end;









