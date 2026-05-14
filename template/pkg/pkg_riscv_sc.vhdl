
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

package pkg_riscv_sc is
  constant REGS_SIZE : integer := 32;       -- 32 words for registers
  constant IMEM_SIZE : integer := 8192;     -- 8192 words for instruction memory => (8192*32Bit)/8  = 32768 Bytes / 1024 = 32 Kb 0x00000000-0x00002000
  constant DMEM_SIZE : integer := 16384;    -- 16384 words for data memory       => (16384*32Bit)/8 = 65536 Bytes / 1024 = 64 Kb 0x00000000-0x00004000

  constant TEXT_SEGMENT_START : unsigned := x"00000000";
  constant TEXT_SEGMENT_END   : unsigned := TEXT_SEGMENT_START + IMEM_SIZE;
  constant DATA_SEGMENT_START : unsigned := x"10000000";
  constant DATA_SEGMENT_END   : unsigned := DATA_SEGMENT_START + DMEM_SIZE;

  constant A0_REG : integer := 10;
  constant A1_REG : integer := 11;

  constant ALU_CTRL_SIZE  : integer := 3;
  constant ALU_CTRL_ADD   : std_ulogic_vector(ALU_CTRL_SIZE-1 downto 0) := "000";
  constant ALU_CTRL_SUB   : std_ulogic_vector(ALU_CTRL_SIZE-1 downto 0) := "001";
  constant ALU_CTRL_AND   : std_ulogic_vector(ALU_CTRL_SIZE-1 downto 0) := "010";
  constant ALU_CTRL_OR    : std_ulogic_vector(ALU_CTRL_SIZE-1 downto 0) := "011";
  constant ALU_CTRL_SLT   : std_ulogic_vector(ALU_CTRL_SIZE-1 downto 0) := "101";
  constant ALU_CTRL_UKNWN : std_ulogic_vector(ALU_CTRL_SIZE-1 downto 0) := "---";


  constant IMM_SRC_SIZE : integer := 3;
  constant EXT_I_TYPE : std_ulogic_vector(IMM_SRC_SIZE-1 downto 0) := "000";
  constant EXT_S_TYPE : std_ulogic_vector(IMM_SRC_SIZE-1 downto 0) := "001";
  constant EXT_B_TYPE : std_ulogic_vector(IMM_SRC_SIZE-1 downto 0) := "010";
  constant EXT_J_TYPE : std_ulogic_vector(IMM_SRC_SIZE-1 downto 0) := "011";
  constant EXT_U_TYPE : std_ulogic_vector(IMM_SRC_SIZE-1 downto 0) := "100";

  -- Define array types
  type regs_ram is array (REGS_SIZE-1 downto 0) of std_ulogic_vector(31 downto 0);
  type imem_ram is array (IMEM_SIZE-1 downto 0) of std_ulogic_vector(31 downto 0);
  type dmem_ram is array (DMEM_SIZE-1 downto 0) of std_ulogic_vector(31 downto 0);

  -- synthesis translate_off
  signal g_ecall : std_ulogic := '0';
  -- synthesis translate_on

  impure function calc_relative_address(address: std_ulogic_vector; segment_start: unsigned) return std_ulogic_vector;
end package pkg_riscv_sc;

package body pkg_riscv_sc is
  impure function calc_relative_address(address: std_ulogic_vector; segment_start: unsigned) return std_ulogic_vector is
    variable unsigned_address : unsigned(31 downto 0);
  begin
    return std_ulogic_vector(unsigned(address) - segment_start);
  end function;
end package body;
