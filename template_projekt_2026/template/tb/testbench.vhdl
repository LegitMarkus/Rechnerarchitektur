library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.pkg_riscv_sc.all;

entity testbench is -- RISC-V testbench
    generic ( TEXT_SEGMENT: string := "./text.txt";
              DATA_SEGMENT: string := "./data.txt";
              REGISTERS   : string := "./regs.txt");
end;

architecture tb of testbench is
  component ICS_EDU_RV32I_SC
    generic ( TEXT_SEGMENT: string;
              DATA_SEGMENT: string;
              REGISTERS   : string);
    port    ( clk, reset  : in STD_ULOGIC;
              ram_regs    : out regs_ram;
              ram_dmem    : out dmem_ram);
  end component;
  
  signal clk, reset: STD_ULOGIC := '0';
  signal ram_regs  : regs_ram;
  signal ram_dmem  : dmem_ram;
begin
  -- instantiate device to be tested
  dut: ICS_EDU_RV32I_SC generic map (TEXT_SEGMENT, DATA_SEGMENT, REGISTERS) port map(clk, reset, ram_regs, ram_dmem);
    
  -- Generate clock with 10 ns period => 100 Mhz
  process begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
  end process;
  
  -- Generate reset for first two clock cycles
  process begin
    reset <= '1';
    --report "INFO: Set Reset" severity note;
    wait for 22 ns;
    reset <= '0';
    --report "INFO: Release Reset" severity note;
    Wait;
  end process;

  process(clk) 
    variable byte_value   : std_ulogic_vector(7 downto 0);
    variable string_end   : boolean;
    variable string_index : integer := 1;
    variable output_string: string(1 to 128);
  begin
    if clk'event and clk = '0' and reset = '0' and g_ecall = '1' then
      case to_integer(unsigned(ram_regs(A0_REG))) is
        when 1 => report "RISC-V Terminal:> " & to_string(to_integer(unsigned(ram_regs(A1_REG)))); -- lw
        when 4 => string_end := false;
                  for i in to_integer(unsigned(calc_relative_address(ram_regs(A1_REG), DATA_SEGMENT_START)(31 downto 2))) to DMEM_SIZE loop
                    for j in 0 to 3 loop
                      if not string_end then
                        byte_value := ram_dmem(i)((j*8) + 7 downto (j*8));
                        output_string(string_index) := character'val(to_integer(unsigned(byte_value)));
                        string_index := string_index + 1;
                        if byte_value = "00000000" then
                          string_end := true;
                          report "RISC-V Terminal:> " & output_string;
                          exit;
                        end if;
                      end if;
                    end loop;
                  end loop;           
        when 10 => report "RISC-V Terminal:> Program ended";
                    std.env.stop; 
        when 11 => 
                report "RISC-V Terminal:> " & character'val(to_integer(unsigned(ram_dmem(to_integer(unsigned(calc_relative_address(ram_regs(A1_REG), DATA_SEGMENT_START))))(31 downto 24)))) severity NOTE; -- beq
        when 17 => report "RISC-V Terminal:> Program ended with return code " & to_string(to_integer(unsigned(ram_regs(A1_REG)))) severity NOTE; -- I-type ALU
                    std.env.stop; 
        when others => report "RISC-V Terminal:> Program ended with invalid ecall: A0: x" & to_hstring(ram_regs(A0_REG)) & " A1: x" & to_hstring(ram_regs(A1_REG)) severity NOTE; -- not valid
                        std.env.stop;
      end case;
      
    end if;
  end process;    

end;
