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

   signal i_btn1_n            : std_logic;
   signal i_btn2_n            : std_logic;
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

   i_btn1_n <= 'H';
   i_btn2_n <= 'H';

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
        IncludeBootStrap   => false,
        PRJ_ROOT           => PRJ_ROOT,
        MOS_NAME           => MOS_NAME,
        SIM                => true
   )
   port map (
         board_clk50     => i_clk_board,
         btn1_n          => i_btn1_n,
         btn2_n          => i_btn2_n,
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
         FLASH_SO       => i_FLASH_SO
    );



   GSR: entity work.GSR
   port map (
      GSRI => i_GSRI
      );


   e_flash:entity fmf.s25fl032a
   generic map (
        mem_file_name       => PRJ_ROOT & "roms/rom_image_64K_beeb.hex",

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
