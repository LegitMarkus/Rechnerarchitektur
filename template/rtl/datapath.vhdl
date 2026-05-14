library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.pkg_riscv_sc.all;

entity datapath is -- RISC-V datapath
  generic ( TEXT_SEGMENT    : string; 
            DATA_SEGMENT    : string; 
            REGISTERS       : string);
  port    ( clk, reset      : in  STD_ULOGIC; 
            ResultSrc       : in  STD_ULOGIC_VECTOR(1  downto 0);
            PCSrc, ALUSrc   : in  STD_ULOGIC;
            RegWrite        : in  STD_ULOGIC;
            MemWrite        : in  STD_ULOGIC;
            ImmSrc          : in  STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1  downto 0);
            ALUControl      : in  STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1  downto 0);
            Zero            : out STD_ULOGIC;
            Instr           : out STD_ULOGIC_VECTOR(31 downto 0);
            ram_regs        : out regs_ram;
            ram_dmem        : out dmem_ram);
end;

architecture struct of datapath is
  component d_ff
    port(clk, reset : in  STD_ULOGIC;
         reset_value: in  STD_ULOGIC_VECTOR(31 downto 0);
         d          : in  STD_ULOGIC_VECTOR(31 downto 0);
         q          : out STD_ULOGIC_VECTOR(31 downto 0));
  end component;

  component adder
    port(a, b : in  STD_ULOGIC_VECTOR(31 downto 0);
         y    : out STD_ULOGIC_VECTOR(31 downto 0));
  end component;

  component mux_2
    port(d0, d1 : in  STD_ULOGIC_VECTOR(31 downto 0);
         s      : in  STD_ULOGIC;
         y      : out STD_ULOGIC_VECTOR(31 downto 0));
  end component;

  component mux_3
    port(d0, d1, d2 : in  STD_ULOGIC_VECTOR(31 downto 0);
         s          : in  STD_ULOGIC_VECTOR(1 downto 0);
         y          : out STD_ULOGIC_VECTOR(31 downto 0));
  end component;

  component register_file
    generic ( REGISTERS : string);
    port    ( clk, reset: in  STD_ULOGIC;
              A1, A2, A3: in  STD_ULOGIC_VECTOR(4  downto 0);
              WE3       : in  STD_ULOGIC;
              WD3       : in  STD_ULOGIC_VECTOR(31 downto 0);
              RD1, RD2  : out STD_ULOGIC_VECTOR(31 downto 0);
              ram_regs  : out regs_ram);
  end component;

  component extend
    port(instr  : in  STD_ULOGIC_VECTOR(31 downto 7);
         immsrc : in  STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1  downto 0);
         immext : out STD_ULOGIC_VECTOR(31 downto 0));
  end component;

  component alu
    port(a, b       : in  STD_ULOGIC_VECTOR(31 downto 0);
         ALUControl : in  STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1  downto 0);
         ALUResult  : out STD_ULOGIC_VECTOR(31 downto 0);
         Zero       : out STD_ULOGIC);
  end component;

  component instruction_memory
    generic ( TEXT_SEGMENT: string);
    port    ( reset       : in STD_ULOGIC;
              a           : in  STD_ULOGIC_VECTOR(31 downto 0);
              rd          : out STD_ULOGIC_VECTOR(31 downto 0));
  end component;

  component data_memory
    generic ( DATA_SEGMENT  : string);
    port    ( clk, reset, WE: in  STD_ULOGIC;
              A, WD         : in  STD_ULOGIC_VECTOR(31 downto 0);
              RD            : out STD_ULOGIC_VECTOR(31 downto 0);
              ram_dmem      : out dmem_ram);
  end component;
    
  signal PCNext, PCPlus4, PCTarget          : STD_ULOGIC_VECTOR(31 downto 0);
  signal ImmExt                             : STD_ULOGIC_VECTOR(31 downto 0);
  signal SrcA, SrcB                         : STD_ULOGIC_VECTOR(31 downto 0);
  signal Result                             : STD_ULOGIC_VECTOR(31 downto 0);
  signal PC, WriteData, ReadData            : STD_ULOGIC_VECTOR(31 downto 0);
  signal ALUResult                          : STD_ULOGIC_VECTOR(31 downto 0);
begin
  -- next PC and extend logic
  pcreg       : d_ff    port map(clk, reset, std_logic_vector(TEXT_SEGMENT_START), PCNext, PC);
  pcadd4      : adder   port map(PC, X"00000004", PCPlus4);
  pcaddbranch : adder   port map(PC, ImmExt, PCTarget);
  pcmux       : mux_2   port map(PCPlus4, PCTarget, PCSrc, PCNext);
  ext         : extend  port map(Instr(31 downto 7), ImmSrc, ImmExt);
    
  -- register file and memory logic
  imem: instruction_memory  generic map (TEXT_SEGMENT) port map(reset, PC, Instr);
  dmem: data_memory         generic map (DATA_SEGMENT) port map(clk, reset, MemWrite, ALUResult, WriteData, ReadData, ram_dmem);
  rf  : register_file       generic map (REGISTERS)    port map(clk, reset, Instr(19 downto 15), Instr(24 downto 20), Instr(11 downto 7), RegWrite, Result, SrcA, WriteData, ram_regs);
    
  -- ALU logic
  srcbmux   :  mux_2 port map(WriteData, ImmExt, ALUSrc, SrcB);
  mainalu   :  alu   port map(SrcA, SrcB,ALUControl, ALUResult, Zero);
  resultmux :  mux_3 port map(ALUResult, ReadData, PCPlus4, ResultSrc, Result);
end;
