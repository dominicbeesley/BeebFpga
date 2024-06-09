--
--Written by GowinSynthesis
--Tool Version "V1.9.9.02"
--Sun Jun  9 23:32:41 2024

--Source file index table:
--file0 "\C:/Users/Dominic/Documents/GitHub/BeebFpga_Dom/src/gowin/gowin_tang_primer25k/src/fifo_sc_top/temp/FIFO_SC/fifo_sc_define.v"
--file1 "\C:/Users/Dominic/Documents/GitHub/BeebFpga_Dom/src/gowin/gowin_tang_primer25k/src/fifo_sc_top/temp/FIFO_SC/fifo_sc_parameter.v"
--file2 "\C:/Gowin/Gowin_V1.9.9.02_x64/IDE/ipcore/FIFO_SC/data/edc_sc.v"
--file3 "\C:/Gowin/Gowin_V1.9.9.02_x64/IDE/ipcore/FIFO_SC/data/fifo_sc.v"
--file4 "\C:/Gowin/Gowin_V1.9.9.02_x64/IDE/ipcore/FIFO_SC/data/fifo_sc_top.v"
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library gw5a;
use gw5a.components.all;

entity watch_events_int is
port(
  Data :  in std_logic_vector(71 downto 0);
  Clk :  in std_logic;
  WrEn :  in std_logic;
  RdEn :  in std_logic;
  Reset :  in std_logic;
  Q :  out std_logic_vector(71 downto 0);
  Empty :  out std_logic;
  Full :  out std_logic);
end watch_events_int;
architecture beh of watch_events_int is
  signal fifo_sc_inst_n387 : std_logic ;
  signal fifo_sc_inst_n387_3 : std_logic ;
  signal fifo_sc_inst_n388 : std_logic ;
  signal fifo_sc_inst_n388_3 : std_logic ;
  signal fifo_sc_inst_n389 : std_logic ;
  signal fifo_sc_inst_n389_3 : std_logic ;
  signal fifo_sc_inst_n390 : std_logic ;
  signal fifo_sc_inst_n390_3 : std_logic ;
  signal fifo_sc_inst_n391 : std_logic ;
  signal fifo_sc_inst_n391_3 : std_logic ;
  signal fifo_sc_inst_n392 : std_logic ;
  signal fifo_sc_inst_n392_3 : std_logic ;
  signal fifo_sc_inst_n393 : std_logic ;
  signal fifo_sc_inst_n393_3 : std_logic ;
  signal fifo_sc_inst_n394 : std_logic ;
  signal fifo_sc_inst_n394_3 : std_logic ;
  signal fifo_sc_inst_n395 : std_logic ;
  signal fifo_sc_inst_n395_3 : std_logic ;
  signal fifo_sc_inst_n7 : std_logic ;
  signal fifo_sc_inst_n11 : std_logic ;
  signal fifo_sc_inst_wfull_val : std_logic ;
  signal fifo_sc_inst_rbin_next_0 : std_logic ;
  signal fifo_sc_inst_wbin_next_0 : std_logic ;
  signal fifo_sc_inst_wfull_val_4 : std_logic ;
  signal fifo_sc_inst_wfull_val_5 : std_logic ;
  signal fifo_sc_inst_wfull_val_6 : std_logic ;
  signal fifo_sc_inst_wfull_val_7 : std_logic ;
  signal fifo_sc_inst_rbin_next_2 : std_logic ;
  signal fifo_sc_inst_rbin_next_5 : std_logic ;
  signal fifo_sc_inst_rbin_next_6 : std_logic ;
  signal fifo_sc_inst_rbin_next_8 : std_logic ;
  signal fifo_sc_inst_rbin_next_9 : std_logic ;
  signal fifo_sc_inst_wbin_next_2 : std_logic ;
  signal fifo_sc_inst_wbin_next_5 : std_logic ;
  signal fifo_sc_inst_wbin_next_6 : std_logic ;
  signal fifo_sc_inst_wbin_next_8 : std_logic ;
  signal fifo_sc_inst_wbin_next_9 : std_logic ;
  signal fifo_sc_inst_wfull_val_8 : std_logic ;
  signal fifo_sc_inst_wfull_val_9 : std_logic ;
  signal fifo_sc_inst_wfull_val_10 : std_logic ;
  signal fifo_sc_inst_rempty_val : std_logic ;
  signal GND_0 : std_logic ;
  signal VCC_0 : std_logic ;
  signal \fifo_sc_inst/rbin\ : std_logic_vector(9 downto 0);
  signal \fifo_sc_inst/wbin\ : std_logic_vector(9 downto 0);
  signal \fifo_sc_inst/rbin_next\ : std_logic_vector(9 downto 1);
  signal \fifo_sc_inst/wbin_next\ : std_logic_vector(9 downto 1);
  signal NN : std_logic;
  signal NN_0 : std_logic;
begin
\fifo_sc_inst/rbin_9_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(9),
  D => \fifo_sc_inst/rbin_next\(9),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_8_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(8),
  D => \fifo_sc_inst/rbin_next\(8),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_7_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(7),
  D => \fifo_sc_inst/rbin_next\(7),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_6_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(6),
  D => \fifo_sc_inst/rbin_next\(6),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_5_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(5),
  D => \fifo_sc_inst/rbin_next\(5),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_4_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(4),
  D => \fifo_sc_inst/rbin_next\(4),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_3_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(3),
  D => \fifo_sc_inst/rbin_next\(3),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_2_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(2),
  D => \fifo_sc_inst/rbin_next\(2),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_1_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(1),
  D => \fifo_sc_inst/rbin_next\(1),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/rbin_0_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/rbin\(0),
  D => fifo_sc_inst_rbin_next_0,
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_9_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(9),
  D => \fifo_sc_inst/wbin_next\(9),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_8_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(8),
  D => \fifo_sc_inst/wbin_next\(8),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_7_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(7),
  D => \fifo_sc_inst/wbin_next\(7),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_6_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(6),
  D => \fifo_sc_inst/wbin_next\(6),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_5_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(5),
  D => \fifo_sc_inst/wbin_next\(5),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_4_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(4),
  D => \fifo_sc_inst/wbin_next\(4),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_3_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(3),
  D => \fifo_sc_inst/wbin_next\(3),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_2_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(2),
  D => \fifo_sc_inst/wbin_next\(2),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_1_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(1),
  D => \fifo_sc_inst/wbin_next\(1),
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/wbin_0_s0\: DFFCE
port map (
  Q => \fifo_sc_inst/wbin\(0),
  D => fifo_sc_inst_wbin_next_0,
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/Full_s0\: DFFCE
port map (
  Q => NN_0,
  D => fifo_sc_inst_wfull_val,
  CLK => Clk,
  CLEAR => Reset,
  CE => VCC_0);
\fifo_sc_inst/Empty_s0\: DFFPE
port map (
  Q => NN,
  D => fifo_sc_inst_rempty_val,
  CLK => Clk,
  PRESET => Reset,
  CE => VCC_0);
\fifo_sc_inst/mem_mem_0_0_s\: SDPX9B
generic map (
  BIT_WIDTH_0 => 36,
  BIT_WIDTH_1 => 36,
  READ_MODE => '0',
  RESET_MODE => "ASYNC",
  BLK_SEL_0 => "000",
  BLK_SEL_1 => "000"
)
port map (
  DO(35 downto 0) => Q(35 downto 0),
  CLKA => Clk,
  CEA => fifo_sc_inst_n7,
  CLKB => Clk,
  CEB => fifo_sc_inst_n11,
  OCE => GND_0,
  RESET => Reset,
  ADA(13 downto 5) => \fifo_sc_inst/wbin\(8 downto 0),
  ADA(4) => GND_0,
  ADA(3) => VCC_0,
  ADA(2) => VCC_0,
  ADA(1) => VCC_0,
  ADA(0) => VCC_0,
  ADB(13 downto 5) => \fifo_sc_inst/rbin\(8 downto 0),
  ADB(4) => GND_0,
  ADB(3) => GND_0,
  ADB(2) => GND_0,
  ADB(1) => GND_0,
  ADB(0) => GND_0,
  BLKSELA(2) => GND_0,
  BLKSELA(1) => GND_0,
  BLKSELA(0) => GND_0,
  BLKSELB(2) => GND_0,
  BLKSELB(1) => GND_0,
  BLKSELB(0) => GND_0,
  DI(35 downto 0) => Data(35 downto 0));
\fifo_sc_inst/mem_mem_0_1_s\: SDPX9B
generic map (
  BIT_WIDTH_0 => 36,
  BIT_WIDTH_1 => 36,
  READ_MODE => '0',
  RESET_MODE => "ASYNC",
  BLK_SEL_0 => "000",
  BLK_SEL_1 => "000"
)
port map (
  DO(35 downto 0) => Q(71 downto 36),
  CLKA => Clk,
  CEA => fifo_sc_inst_n7,
  CLKB => Clk,
  CEB => fifo_sc_inst_n11,
  OCE => GND_0,
  RESET => Reset,
  ADA(13 downto 5) => \fifo_sc_inst/wbin\(8 downto 0),
  ADA(4) => GND_0,
  ADA(3) => VCC_0,
  ADA(2) => VCC_0,
  ADA(1) => VCC_0,
  ADA(0) => VCC_0,
  ADB(13 downto 5) => \fifo_sc_inst/rbin\(8 downto 0),
  ADB(4) => GND_0,
  ADB(3) => GND_0,
  ADB(2) => GND_0,
  ADB(1) => GND_0,
  ADB(0) => GND_0,
  BLKSELA(2) => GND_0,
  BLKSELA(1) => GND_0,
  BLKSELA(0) => GND_0,
  BLKSELB(2) => GND_0,
  BLKSELB(1) => GND_0,
  BLKSELB(0) => GND_0,
  DI(35 downto 0) => Data(71 downto 36));
\fifo_sc_inst/n387_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n387,
  COUT => fifo_sc_inst_n387_3,
  I0 => fifo_sc_inst_rbin_next_0,
  I1 => \fifo_sc_inst/wbin\(0),
  I3 => GND_0,
  CIN => GND_0);
\fifo_sc_inst/n388_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n388,
  COUT => fifo_sc_inst_n388_3,
  I0 => \fifo_sc_inst/rbin_next\(1),
  I1 => \fifo_sc_inst/wbin\(1),
  I3 => GND_0,
  CIN => fifo_sc_inst_n387_3);
\fifo_sc_inst/n389_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n389,
  COUT => fifo_sc_inst_n389_3,
  I0 => \fifo_sc_inst/rbin_next\(2),
  I1 => \fifo_sc_inst/wbin\(2),
  I3 => GND_0,
  CIN => fifo_sc_inst_n388_3);
\fifo_sc_inst/n390_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n390,
  COUT => fifo_sc_inst_n390_3,
  I0 => \fifo_sc_inst/rbin_next\(3),
  I1 => \fifo_sc_inst/wbin\(3),
  I3 => GND_0,
  CIN => fifo_sc_inst_n389_3);
\fifo_sc_inst/n391_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n391,
  COUT => fifo_sc_inst_n391_3,
  I0 => \fifo_sc_inst/rbin_next\(4),
  I1 => \fifo_sc_inst/wbin\(4),
  I3 => GND_0,
  CIN => fifo_sc_inst_n390_3);
\fifo_sc_inst/n392_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n392,
  COUT => fifo_sc_inst_n392_3,
  I0 => \fifo_sc_inst/rbin_next\(5),
  I1 => \fifo_sc_inst/wbin\(5),
  I3 => GND_0,
  CIN => fifo_sc_inst_n391_3);
\fifo_sc_inst/n393_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n393,
  COUT => fifo_sc_inst_n393_3,
  I0 => \fifo_sc_inst/rbin_next\(6),
  I1 => \fifo_sc_inst/wbin\(6),
  I3 => GND_0,
  CIN => fifo_sc_inst_n392_3);
\fifo_sc_inst/n394_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n394,
  COUT => fifo_sc_inst_n394_3,
  I0 => \fifo_sc_inst/rbin_next\(7),
  I1 => \fifo_sc_inst/wbin\(7),
  I3 => GND_0,
  CIN => fifo_sc_inst_n393_3);
\fifo_sc_inst/n395_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_sc_inst_n395,
  COUT => fifo_sc_inst_n395_3,
  I0 => \fifo_sc_inst/rbin_next\(8),
  I1 => \fifo_sc_inst/wbin\(8),
  I3 => GND_0,
  CIN => fifo_sc_inst_n394_3);
\fifo_sc_inst/n7_s1\: LUT2
generic map (
  INIT => X"4"
)
port map (
  F => fifo_sc_inst_n7,
  I0 => NN_0,
  I1 => WrEn);
\fifo_sc_inst/n11_s0\: LUT2
generic map (
  INIT => X"4"
)
port map (
  F => fifo_sc_inst_n11,
  I0 => NN,
  I1 => RdEn);
\fifo_sc_inst/wfull_val_s0\: LUT4
generic map (
  INIT => X"8000"
)
port map (
  F => fifo_sc_inst_wfull_val,
  I0 => fifo_sc_inst_wfull_val_4,
  I1 => fifo_sc_inst_wfull_val_5,
  I2 => fifo_sc_inst_wfull_val_6,
  I3 => fifo_sc_inst_wfull_val_7);
\fifo_sc_inst/rbin_next_0_s3\: LUT3
generic map (
  INIT => X"B4"
)
port map (
  F => fifo_sc_inst_rbin_next_0,
  I0 => NN,
  I1 => RdEn,
  I2 => \fifo_sc_inst/rbin\(0));
\fifo_sc_inst/rbin_next_1_s3\: LUT4
generic map (
  INIT => X"BF40"
)
port map (
  F => \fifo_sc_inst/rbin_next\(1),
  I0 => NN,
  I1 => RdEn,
  I2 => \fifo_sc_inst/rbin\(0),
  I3 => \fifo_sc_inst/rbin\(1));
\fifo_sc_inst/rbin_next_2_s3\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => \fifo_sc_inst/rbin_next\(2),
  I0 => \fifo_sc_inst/rbin\(2),
  I1 => fifo_sc_inst_rbin_next_2);
\fifo_sc_inst/rbin_next_3_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_sc_inst/rbin_next\(3),
  I0 => \fifo_sc_inst/rbin\(2),
  I1 => fifo_sc_inst_rbin_next_2,
  I2 => \fifo_sc_inst/rbin\(3));
\fifo_sc_inst/rbin_next_4_s3\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_sc_inst/rbin_next\(4),
  I0 => \fifo_sc_inst/rbin\(2),
  I1 => \fifo_sc_inst/rbin\(3),
  I2 => fifo_sc_inst_rbin_next_2,
  I3 => \fifo_sc_inst/rbin\(4));
\fifo_sc_inst/rbin_next_5_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_sc_inst/rbin_next\(5),
  I0 => fifo_sc_inst_rbin_next_2,
  I1 => fifo_sc_inst_rbin_next_5,
  I2 => \fifo_sc_inst/rbin\(5));
\fifo_sc_inst/rbin_next_6_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_sc_inst/rbin_next\(6),
  I0 => fifo_sc_inst_rbin_next_6,
  I1 => fifo_sc_inst_rbin_next_2,
  I2 => \fifo_sc_inst/rbin\(6));
\fifo_sc_inst/rbin_next_7_s3\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_sc_inst/rbin_next\(7),
  I0 => \fifo_sc_inst/rbin\(6),
  I1 => fifo_sc_inst_rbin_next_6,
  I2 => fifo_sc_inst_rbin_next_2,
  I3 => \fifo_sc_inst/rbin\(7));
\fifo_sc_inst/rbin_next_8_s3\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_sc_inst/rbin_next\(8),
  I0 => fifo_sc_inst_rbin_next_6,
  I1 => fifo_sc_inst_rbin_next_2,
  I2 => fifo_sc_inst_rbin_next_8,
  I3 => \fifo_sc_inst/rbin\(8));
\fifo_sc_inst/rbin_next_9_s2\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_sc_inst/rbin_next\(9),
  I0 => fifo_sc_inst_rbin_next_9,
  I1 => fifo_sc_inst_rbin_next_6,
  I2 => fifo_sc_inst_rbin_next_2,
  I3 => \fifo_sc_inst/rbin\(9));
\fifo_sc_inst/wbin_next_0_s3\: LUT3
generic map (
  INIT => X"B4"
)
port map (
  F => fifo_sc_inst_wbin_next_0,
  I0 => NN_0,
  I1 => WrEn,
  I2 => \fifo_sc_inst/wbin\(0));
\fifo_sc_inst/wbin_next_1_s3\: LUT4
generic map (
  INIT => X"BF40"
)
port map (
  F => \fifo_sc_inst/wbin_next\(1),
  I0 => NN_0,
  I1 => WrEn,
  I2 => \fifo_sc_inst/wbin\(0),
  I3 => \fifo_sc_inst/wbin\(1));
\fifo_sc_inst/wbin_next_2_s3\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => \fifo_sc_inst/wbin_next\(2),
  I0 => \fifo_sc_inst/wbin\(2),
  I1 => fifo_sc_inst_wbin_next_2);
\fifo_sc_inst/wbin_next_3_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_sc_inst/wbin_next\(3),
  I0 => \fifo_sc_inst/wbin\(2),
  I1 => fifo_sc_inst_wbin_next_2,
  I2 => \fifo_sc_inst/wbin\(3));
\fifo_sc_inst/wbin_next_4_s3\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_sc_inst/wbin_next\(4),
  I0 => \fifo_sc_inst/wbin\(2),
  I1 => \fifo_sc_inst/wbin\(3),
  I2 => fifo_sc_inst_wbin_next_2,
  I3 => \fifo_sc_inst/wbin\(4));
\fifo_sc_inst/wbin_next_5_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_sc_inst/wbin_next\(5),
  I0 => fifo_sc_inst_wbin_next_2,
  I1 => fifo_sc_inst_wbin_next_5,
  I2 => \fifo_sc_inst/wbin\(5));
\fifo_sc_inst/wbin_next_6_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_sc_inst/wbin_next\(6),
  I0 => fifo_sc_inst_wbin_next_2,
  I1 => fifo_sc_inst_wbin_next_6,
  I2 => \fifo_sc_inst/wbin\(6));
\fifo_sc_inst/wbin_next_7_s3\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_sc_inst/wbin_next\(7),
  I0 => \fifo_sc_inst/wbin\(6),
  I1 => fifo_sc_inst_wbin_next_2,
  I2 => fifo_sc_inst_wbin_next_6,
  I3 => \fifo_sc_inst/wbin\(7));
\fifo_sc_inst/wbin_next_8_s3\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_sc_inst/wbin_next\(8),
  I0 => fifo_sc_inst_wbin_next_2,
  I1 => fifo_sc_inst_wbin_next_6,
  I2 => fifo_sc_inst_wbin_next_8,
  I3 => \fifo_sc_inst/wbin\(8));
\fifo_sc_inst/wbin_next_9_s2\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_sc_inst/wbin_next\(9),
  I0 => fifo_sc_inst_wbin_next_9,
  I1 => fifo_sc_inst_wbin_next_2,
  I2 => fifo_sc_inst_wbin_next_6,
  I3 => \fifo_sc_inst/wbin\(9));
\fifo_sc_inst/wfull_val_s1\: LUT4
generic map (
  INIT => X"0990"
)
port map (
  F => fifo_sc_inst_wfull_val_4,
  I0 => \fifo_sc_inst/rbin_next\(5),
  I1 => \fifo_sc_inst/wbin_next\(5),
  I2 => \fifo_sc_inst/rbin_next\(9),
  I3 => \fifo_sc_inst/wbin_next\(9));
\fifo_sc_inst/wfull_val_s2\: LUT4
generic map (
  INIT => X"8241"
)
port map (
  F => fifo_sc_inst_wfull_val_5,
  I0 => fifo_sc_inst_wfull_val_8,
  I1 => \fifo_sc_inst/wbin_next\(8),
  I2 => \fifo_sc_inst/rbin_next\(8),
  I3 => \fifo_sc_inst/rbin\(6));
\fifo_sc_inst/wfull_val_s3\: LUT4
generic map (
  INIT => X"8200"
)
port map (
  F => fifo_sc_inst_wfull_val_6,
  I0 => fifo_sc_inst_wfull_val_9,
  I1 => \fifo_sc_inst/rbin_next\(3),
  I2 => \fifo_sc_inst/wbin_next\(3),
  I3 => fifo_sc_inst_wfull_val_10);
\fifo_sc_inst/wfull_val_s4\: LUT4
generic map (
  INIT => X"9009"
)
port map (
  F => fifo_sc_inst_wfull_val_7,
  I0 => \fifo_sc_inst/wbin_next\(4),
  I1 => \fifo_sc_inst/rbin_next\(4),
  I2 => \fifo_sc_inst/wbin_next\(7),
  I3 => \fifo_sc_inst/rbin_next\(7));
\fifo_sc_inst/rbin_next_2_s4\: LUT4
generic map (
  INIT => X"4000"
)
port map (
  F => fifo_sc_inst_rbin_next_2,
  I0 => NN,
  I1 => RdEn,
  I2 => \fifo_sc_inst/rbin\(0),
  I3 => \fifo_sc_inst/rbin\(1));
\fifo_sc_inst/rbin_next_5_s4\: LUT3
generic map (
  INIT => X"80"
)
port map (
  F => fifo_sc_inst_rbin_next_5,
  I0 => \fifo_sc_inst/rbin\(2),
  I1 => \fifo_sc_inst/rbin\(3),
  I2 => \fifo_sc_inst/rbin\(4));
\fifo_sc_inst/rbin_next_6_s4\: LUT4
generic map (
  INIT => X"8000"
)
port map (
  F => fifo_sc_inst_rbin_next_6,
  I0 => \fifo_sc_inst/rbin\(2),
  I1 => \fifo_sc_inst/rbin\(3),
  I2 => \fifo_sc_inst/rbin\(4),
  I3 => \fifo_sc_inst/rbin\(5));
\fifo_sc_inst/rbin_next_8_s4\: LUT2
generic map (
  INIT => X"8"
)
port map (
  F => fifo_sc_inst_rbin_next_8,
  I0 => \fifo_sc_inst/rbin\(6),
  I1 => \fifo_sc_inst/rbin\(7));
\fifo_sc_inst/rbin_next_9_s3\: LUT3
generic map (
  INIT => X"80"
)
port map (
  F => fifo_sc_inst_rbin_next_9,
  I0 => \fifo_sc_inst/rbin\(6),
  I1 => \fifo_sc_inst/rbin\(7),
  I2 => \fifo_sc_inst/rbin\(8));
\fifo_sc_inst/wbin_next_2_s4\: LUT4
generic map (
  INIT => X"4000"
)
port map (
  F => fifo_sc_inst_wbin_next_2,
  I0 => NN_0,
  I1 => WrEn,
  I2 => \fifo_sc_inst/wbin\(0),
  I3 => \fifo_sc_inst/wbin\(1));
\fifo_sc_inst/wbin_next_5_s4\: LUT3
generic map (
  INIT => X"80"
)
port map (
  F => fifo_sc_inst_wbin_next_5,
  I0 => \fifo_sc_inst/wbin\(2),
  I1 => \fifo_sc_inst/wbin\(3),
  I2 => \fifo_sc_inst/wbin\(4));
\fifo_sc_inst/wbin_next_6_s4\: LUT4
generic map (
  INIT => X"8000"
)
port map (
  F => fifo_sc_inst_wbin_next_6,
  I0 => \fifo_sc_inst/wbin\(2),
  I1 => \fifo_sc_inst/wbin\(3),
  I2 => \fifo_sc_inst/wbin\(4),
  I3 => \fifo_sc_inst/wbin\(5));
\fifo_sc_inst/wbin_next_8_s4\: LUT2
generic map (
  INIT => X"8"
)
port map (
  F => fifo_sc_inst_wbin_next_8,
  I0 => \fifo_sc_inst/wbin\(6),
  I1 => \fifo_sc_inst/wbin\(7));
\fifo_sc_inst/wbin_next_9_s3\: LUT3
generic map (
  INIT => X"80"
)
port map (
  F => fifo_sc_inst_wbin_next_9,
  I0 => \fifo_sc_inst/wbin\(6),
  I1 => \fifo_sc_inst/wbin\(7),
  I2 => \fifo_sc_inst/wbin\(8));
\fifo_sc_inst/wfull_val_s5\: LUT4
generic map (
  INIT => X"E718"
)
port map (
  F => fifo_sc_inst_wfull_val_8,
  I0 => fifo_sc_inst_wbin_next_2,
  I1 => fifo_sc_inst_wbin_next_6,
  I2 => fifo_sc_inst_rbin_next_6,
  I3 => \fifo_sc_inst/wbin\(6));
\fifo_sc_inst/wfull_val_s6\: LUT4
generic map (
  INIT => X"9669"
)
port map (
  F => fifo_sc_inst_wfull_val_9,
  I0 => \fifo_sc_inst/rbin\(2),
  I1 => \fifo_sc_inst/wbin\(2),
  I2 => fifo_sc_inst_wbin_next_2,
  I3 => fifo_sc_inst_rbin_next_2);
\fifo_sc_inst/wfull_val_s7\: LUT4
generic map (
  INIT => X"9009"
)
port map (
  F => fifo_sc_inst_wfull_val_10,
  I0 => \fifo_sc_inst/rbin_next\(1),
  I1 => \fifo_sc_inst/wbin_next\(1),
  I2 => fifo_sc_inst_rbin_next_0,
  I3 => fifo_sc_inst_wbin_next_0);
\fifo_sc_inst/rempty_val_s1\: LUT3
generic map (
  INIT => X"09"
)
port map (
  F => fifo_sc_inst_rempty_val,
  I0 => \fifo_sc_inst/rbin_next\(9),
  I1 => \fifo_sc_inst/wbin\(9),
  I2 => fifo_sc_inst_n395_3);
GND_s0: GND
port map (
  G => GND_0);
VCC_s0: VCC
port map (
  V => VCC_0);
GSR_0: GSR
port map (
  GSRI => VCC_0);
  Empty <= NN;
  Full <= NN_0;
end beh;
