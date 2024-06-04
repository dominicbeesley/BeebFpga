library vunit_lib;
context vunit_lib.vunit_context;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use std.textio.all;

library work;

library fmf;

entity test_tb is
   generic (
      runner_cfg : string;
      BOARD_CLOCK_FREQ : natural := 50000000;
      PRJ_ROOT : string := "../../../../";
      MOS_NAME : string := "vunit_test/sim_asm/simple_mos/build/simple-mos.rom.bit"
      );
end test_tb;

architecture rtl of test_tb is

   signal i_clk_board         : std_logic;

   signal i_btn1              : std_logic;
   signal i_btn2              : std_logic;
   signal i_ps2_clk           : std_logic;
   signal i_ps2_data          : std_logic;
   signal i_ps2_mouse_clk     : std_logic;
   signal i_ps2_mouse_data    : std_logic;
   signal i_tf_miso           : std_logic;
   signal i_tf_cs             : std_logic;
   signal i_tf_sclk           : std_logic;
   signal i_tf_mosi           : std_logic;
   signal i_uart_rx           : std_logic;
   signal i_uart_tx           : std_logic;

   signal i_sdram_DQ       : std_logic_vector(15 downto 0);
   signal i_sdram_A        : std_logic_vector(12 downto 0); 
   signal i_sdram_BS       : std_logic_vector(1 downto 0); 
   signal i_sdram_CLK      : std_logic;
   signal i_sdram_CKE      : std_logic;
   signal i_sdram_nCS      : std_logic;
   signal i_sdram_nRAS     : std_logic;
   signal i_sdram_nCAS     : std_logic;
   signal i_sdram_nWE      : std_logic;
   signal i_sdram_DQM      : std_logic_vector(1 downto 0);

   signal i_GSRI              : std_logic;

   signal i_FLASH_CS          : std_logic;
   signal i_FLASH_SI          : std_logic;
   signal i_FLASH_CK          : std_logic;
   signal i_FLASH_SO          : std_logic;

begin
   p_clk:process
   constant PER2 : time := 500000 us / BOARD_CLOCK_FREQ;
   begin
      i_clk_board <= '0';
      wait for PER2;
      i_clk_board <= '1';
      wait for PER2;
   end process;

   p_rst:process
   begin
      i_GSRI <= '0';
      wait for 1 us;
      i_GSRI <= '1';
      wait;
   end process;

   i_btn1 <= 'L';
   i_btn2 <= 'L';

   i_ps2_clk <= 'H';
   i_ps2_data <= 'H';
   i_ps2_mouse_clk <= 'H';
   i_ps2_mouse_data <= 'H';

   i_tf_miso <= 'H';
   i_uart_rx <= 'H';

   p_main:process
   begin

      test_runner_setup(runner, runner_cfg);


      while test_suite loop

         if run("write then read") then
   
            wait for 100000 us;

         end if;

      end loop;

      wait for 3 us;

      test_runner_cleanup(runner); -- Simulation ends here
   end process;

   e_dut:entity work.bbc_micro_tang_primer25k
   generic map (
        IncludeAMXMouse    => false,
        IncludeSID         => false,
        IncludeHDMI        => false,
        IncludeMaster      => false,
        IncludeBootStrap   => true,
        PRJ_ROOT           => PRJ_ROOT,
        MOS_NAME           => MOS_NAME,
        SIM                => true
   )
   port map (
         board_clk50     => i_clk_board,
         btn1            => i_btn1,
         btn2            => i_btn2,
         ps2_clk         => i_ps2_clk,
         ps2_data        => i_ps2_data,
         ps2_mouse_clk   => i_ps2_mouse_clk,
         ps2_mouse_data  => i_ps2_mouse_data,

         tf_miso         => i_tf_miso,
         tf_cs           => i_tf_cs,
         tf_sclk         => i_tf_sclk,
         tf_mosi         => i_tf_mosi,
         uart_rx         => i_uart_rx,
         uart_tx         => i_uart_tx,

         FLASH_CS       => i_FLASH_CS,
         FLASH_SI       => i_FLASH_SI,
         FLASH_CK       => i_FLASH_CK,
         FLASH_SO       => i_FLASH_SO,

         sdram_clk_o    => i_sdram_CLK,
         sdram_DQ_io    => i_sdram_DQ,
         sdram_A_o      => i_sdram_A,
         sdram_BS_o     => i_sdram_BS,
         sdram_nCS_o    => i_sdram_nCS,
         sdram_nRAS_o   => i_sdram_nRAS,
         sdram_nCAS_o   => i_sdram_nCAS,
         sdram_nWE_o    => i_sdram_nWE,
         sdram_DQM_o    => i_sdram_DQM

    );

   i_sdram_CKE <= '1';

   e_sdram:entity work.W9825G6KH
   port map (
      Dq       => i_sdram_DQ,
      Addr     => i_sdram_A,
      Bs       => i_sdram_BS,
      Clk      => i_sdram_CLK,
      Cke      => i_sdram_CKE,
      Cs_n     => i_sdram_nCS,
      Ras_n    => i_sdram_nRAS,
      Cas_n    => i_sdram_nCAS,
      We_n     => i_sdram_nWE,
      Dqm      => i_sdram_DQM
      --Dqm    => "00"
    );


   GSR: entity work.GSR
   port map (
      GSRI => i_GSRI
      );


   e_flash:entity fmf.s25fl032a
   generic map (
        mem_file_name       => PRJ_ROOT & "roms/rom_image_64K_beeb_500000.hex",

        UserPreload         => true,

        tdevice_PU => 1 us

    )
    port map(
        SCK             => i_FLASH_CK,
        SI              => i_FLASH_SI,
        CSNeg           => i_FLASH_CS,
        HOLDNeg         => '1',
        WNeg            => '0',
        SO              => i_FLASH_SO
    );

   i_FLASH_SO <= 'H';




end rtl;
