-- BBC Master / BBC B for the Tang Nano 20K
--
-- Copright (c) 2023 Dominic Beesley
-- Copright (c) 2023 David Banks
--
-- Based on previous work by Mike Stirling
--
-- Copyright (c) 2011 Mike Stirling
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- * Redistributions in synthesized form must reproduce the above copyright
--   notice, this list of conditions and the following disclaimer in the
--   documentation and/or other materials provided with the distribution.
--
-- * Neither the name of the author nor the names of other contributors may
--   be used to endorse or promote products derived from this software without
--   specific prior written agreement from the author.
--
-- * License is granted for non-commercial use only.  A fee may not be charged
--   for redistributions as source code or in synthesized/hardware form without
--   specific prior written agreement from the author.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use work.common.all;

entity bbc_micro_tang20k is
    generic (
        IncludeMaster      : boolean := true; -- if both included, the CPU is the AlanD 65C02
        IncludeBeeb        : boolean := true; -- and btn1 can toggle between the ROM images

        IncludeAMXMouse    : boolean := false;
        IncludeSPISD       : boolean := true;
        IncludeSID         : boolean := true;
        IncludeMusic5000   : boolean := false; -- doesn't meet timing, but seems to work
        IncludeVideoNuLA   : boolean := true;
        IncludeTrace       : boolean := true;
        IncludeHDMI        : boolean := false;
        IncludeBootStrap   : boolean := true;
        IncludeMonitor     : boolean := true;

        PRJ_ROOT           : string  := "../../..";
        MOS_NAME           : string  := "/roms/bbcb/os12_basic.bit";
        SIM                : boolean := false
        );
    port (
        sys_clk         : in    std_logic;
        btn1            : in    std_logic;     -- Toggle Master / Beeb modes
        btn2            : in    std_logic;     -- Toggle HDMI / DVI modes
        led             : out   std_logic_vector (5 downto 0);

        -- Keyboard / Mouse
        ps2_clk         : inout std_logic;
        ps2_data        : inout std_logic;
        ps2_mouse_clk   : inout std_logic;
        ps2_mouse_data  : inout std_logic;

        -- SD Card
        tf_miso         : in    std_logic;
        tf_cs           : out   std_logic;
        tf_sclk         : out   std_logic;
        tf_mosi         : out   std_logic;

        -- USB UART
        uart_rx         : in    std_logic;
        uart_tx         : out   std_logic;

        -- 1 bit video
        vid_r_o         : out   std_logic;
        vid_g_o         : out   std_logic;
        vid_b_o         : out   std_logic;
        vid_cs_o        : out   std_logic;
        vid_chr_o       : out   std_logic;

        -- Magic ports for SDRAM to be inferred
        O_sdram_clk     : out   std_logic;
        O_sdram_cke     : out   std_logic;
        O_sdram_cs_n    : out   std_logic;
        O_sdram_cas_n   : out   std_logic;
        O_sdram_ras_n   : out   std_logic;
        O_sdram_wen_n   : out   std_logic;
        IO_sdram_dq     : inout std_logic_vector(31 downto 0);
        O_sdram_addr    : out   std_logic_vector(10 downto 0);
        O_sdram_ba      : out   std_logic_vector(1 downto 0);
        O_sdram_dqm     : out   std_logic_vector(3 downto 0);

        -- A general purpose 14-bit bus, that we can use for several functions such as 6502 tracing
        -- Bits 12/13 double as audio
        -- gpio            : out   std_logic_vector(13 downto 0);

        -- SPI Flash (for ROM data)
        flash_cs        : out   std_logic;     -- Active low FLASH chip select
        flash_si        : out   std_logic;     -- Serial output to FLASH chip SI pin
        flash_ck        : out   std_logic;     -- FLASH clock
        flash_so        : in    std_logic      -- Serial input from FLASH chip SO pin
        );
end entity;

architecture rtl of bbc_micro_tang20k is

    --------------------------------------------------------
    -- FPGA Primitive Components
    --------------------------------------------------------

    component rPLL
        generic (
            FCLKIN: in string := "100.0";
            DEVICE: in string := "GW1N-4";
            DYN_IDIV_SEL: in string := "false";
            IDIV_SEL: in integer := 0;
            DYN_FBDIV_SEL: in string := "false";
            FBDIV_SEL: in integer := 0;
            DYN_ODIV_SEL: in string := "false";
            ODIV_SEL: in integer := 8;
            PSDA_SEL: in string := "0000";
            DYN_DA_EN: in string := "false";
            DUTYDA_SEL: in string := "1000";
            CLKOUT_FT_DIR: in bit := '1';
            CLKOUTP_FT_DIR: in bit := '1';
            CLKOUT_DLY_STEP: in integer := 0;
            CLKOUTP_DLY_STEP: in integer := 0;
            CLKOUTD3_SRC: in string := "CLKOUT";
            CLKFB_SEL: in string := "internal";
            CLKOUT_BYPASS: in string := "false";
            CLKOUTP_BYPASS: in string := "false";
            CLKOUTD_BYPASS: in string := "false";
            CLKOUTD_SRC: in string := "CLKOUT";
            DYN_SDIV_SEL: in integer := 2
        );
        port (
            CLKOUT: out std_logic;
            LOCK: out std_logic;
            CLKOUTP: out std_logic;
            CLKOUTD: out std_logic;
            CLKOUTD3: out std_logic;
            RESET: in std_logic;
            RESET_P: in std_logic;
            CLKIN: in std_logic;
            CLKFB: in std_logic;
            FBDSEL: in std_logic_vector(5 downto 0);
            IDSEL: in std_logic_vector(5 downto 0);
            ODSEL: in std_logic_vector(5 downto 0);
            PSDA: in std_logic_vector(3 downto 0);
            DUTYDA: in std_logic_vector(3 downto 0);
            FDLY: in std_logic_vector(3 downto 0)
        );
    end component;


    --------------------------------------------------------
    -- Functions
    --------------------------------------------------------

    function RESETBITS return natural is
    begin
        if SIM then
            return 10;
        else
            return 24; --DB: > 10ms for SPI to start up?
        end if;
    end function;

    --------------------------------------------------------
    -- Signals
    --------------------------------------------------------

    signal clock_27        : std_logic;
    signal clock_48        : std_logic;
    signal clock_96        : std_logic;
    signal clock_96_p      : std_logic;
    signal mem_ready       : std_logic;

    signal dac_l_in        : std_logic_vector(9 downto 0);
    signal dac_r_in        : std_logic_vector(9 downto 0);
    signal audio_l         : std_logic_vector(15 downto 0);
    signal audio_r         : std_logic_vector(15 downto 0);
    signal audiol          : std_logic;
    signal audior          : std_logic;

    signal config_counter  : std_logic_vector(21 downto 0);
    signal config_last     : std_logic;

    signal powerup_reset_n : std_logic := '0';
    signal hard_reset_n    : std_logic;
    signal reset_counter   : std_logic_vector(RESETBITS downto 0);

    signal ext_A_stb       : std_logic;
    signal ext_A           : std_logic_vector (18 downto 0);
    signal ext_Din         : std_logic_vector (7 downto 0);
    signal ext_Dout        : std_logic_vector (7 downto 0);
    signal ext_nCS         : std_logic;
    signal ext_nWE         : std_logic;
    signal ext_nWE_long    : std_logic;
    signal ext_nOE         : std_logic;

    signal keyb_dip        : std_logic_vector(7 downto 0);
    signal vid_mode        : std_logic_vector(3 downto 0);
    signal m128_mode       : std_logic := '1';

    signal caps_led        : std_logic;
    signal shift_led       : std_logic;

    signal i_VGA_R         : std_logic_vector(3 downto 0);
    signal i_VGA_G         : std_logic_vector(3 downto 0);
    signal i_VGA_B         : std_logic_vector(3 downto 0);
    signal i_VGA_HS        : std_logic;
    signal i_VGA_VS        : std_logic;
    signal i_VGA_DE        : std_logic;
    signal i_VGA_CLKEN     : std_logic;
    signal i_VGA_MHZ12     : std_logic;

    -- CPU tracing
    signal trace_data      :   std_logic_vector(7 downto 0);
    signal trace_r_nw      :   std_logic;
    signal trace_sync      :   std_logic;
    signal trace_rstn      :   std_logic;
    signal trace_phi2      :   std_logic;

    -- Mem Controller Monior LEDs
    signal monitor_leds    :   std_logic_vector(5 downto 0);

    signal vid_r_r          : unsigned(3 downto 0);
    signal vid_g_r          : unsigned(3 downto 0);
    signal vid_b_r          : unsigned(3 downto 0);

    signal vid_r_r2         : unsigned(3 downto 0);
    signal vid_g_r2         : unsigned(3 downto 0);
    signal vid_b_r2         : unsigned(3 downto 0);

    signal vid_req          : std_logic;
    signal vid_ack          : std_logic;

    signal i_clk_216        : std_logic;

begin

    --------------------------------------------------------
    -- BBC Micro Core
    --------------------------------------------------------

    bbc_micro : entity work.bbc_micro_core
        generic map (
            IncludeAMXMouse    => IncludeAMXMouse,
            IncludeSPISD       => IncludeSPISD,
            IncludeSID         => IncludeSID,
            IncludeMusic5000   => IncludeMusic5000,
            IncludeICEDebugger => false,
            IncludeCoPro6502   => false,
            IncludeCoProSPI    => false,
            IncludeCoProExt    => false,
            IncludeVideoNuLA   => IncludeVideoNuLA,
            IncludeTrace       => IncludeTrace,
            IncludeHDMI        => IncludeHDMI,
            UseOrigKeyboard    => false,
            UseT65Core         => not IncludeMaster,
            UseAlanDCore       => IncludeMaster
        )
        port map (
            clock_27       => '1',
            clock_32       => '0',                 -- Unused now in the core
            clock_48       => clock_48,
            clock_96       => clock_96,
            clock_avr      => '0',                 -- DB: no AVR yet
            hard_reset_n   => hard_reset_n,
            ps2_kbd_clk    => ps2_clk,
            ps2_kbd_data   => ps2_data,
            ps2_mse_clk    => ps2_mouse_clk,
            ps2_mse_data   => ps2_mouse_data,
            video_red      => i_VGA_R,
            video_green    => i_VGA_G,
            video_blue     => i_VGA_B,
            video_hsync    => i_VGA_hs,
            video_vsync    => i_VGA_vs,
            video_disen    => i_VGA_de,
            video_clken    => i_VGA_CLKEN,
            video_mhz12    => i_VGA_MHZ12,
            audio_l        => audio_l,
            audio_r        => audio_r,
            ext_nOE        => ext_nOE,
            ext_nWE        => ext_nWE,
            ext_nWE_long   => ext_nWE_long,
            ext_nCS        => ext_nCS,
            ext_A          => ext_A,
            ext_A_stb      => ext_A_stb,
            ext_Dout       => ext_Dout,
            ext_Din        => ext_Din,
            SDMISO         => tf_miso,
            SDSS           => tf_cs,
            SDCLK          => tf_sclk,
            SDMOSI         => tf_mosi,
            caps_led       => caps_led,
            shift_led      => shift_led,
            keyb_dip       => keyb_dip,
            ext_keyb_led1  => open,
            ext_keyb_led2  => open,
            ext_keyb_led3  => open,
            ext_keyb_1mhz  => open,
            ext_keyb_en_n  => open,
            ext_keyb_pa    => open,
            ext_keyb_rst_n => '1',
            ext_keyb_ca2   => '0',
            ext_keyb_pa7   => '0',
            vid_mode       => vid_mode,
            joystick1      => (others => '1'),
            joystick2      => (others => '1'),
            avr_reset      => not hard_reset_n,
            avr_RxD        => uart_rx,
            avr_TxD        => uart_tx,
            cpu_addr       => open,
            m128_mode      => m128_mode,
            copro_mode     => '0',
            p_spi_ssel     => '0',
            p_spi_sck      => '0',
            p_spi_mosi     => '0',
            p_spi_miso     => open,
            p_irq_b        => open,
            p_nmi_b        => open,
            p_rst_b        => open,
            ext_tube_r_nw  => open,
            ext_tube_nrst  => open,
            ext_tube_ntube => open,
            ext_tube_phi2  => open,
            ext_tube_a     => open,
            ext_tube_di    => open,
            ext_tube_do    => (others => '0'),
--            hdmi_aspect    => hdmi_aspect,
--            hdmi_audio_en  => hdmi_audio_en,
--            vid_debug      => vid_debug,
--            tmds_r         => tmds_r,
--            tmds_g         => tmds_g,
--            tmds_b         => tmds_b,
--            hsync_ref      => hsync_ref,
            trace_data     => trace_data,
            trace_r_nw     => trace_r_nw,
            trace_sync     => trace_sync,
            trace_rstn     => trace_rstn,
            trace_phi2     => trace_phi2,
            test           => open
        );

    --vid_mode       <= "0001" when IncludeHDMI else "0000";
    vid_mode <= "0000"; -- DB: force for LCD test

    keyb_dip       <= "00000011";

    --------------------------------------------------------
    -- Clock Generation
    --------------------------------------------------------

    -- 48 MHz master clock from 27MHz input clock
    -- plus intermediate 96MHz clock for scan doubler

    pll1 : rPLL
        generic map (
            FCLKIN => "27",
            DEVICE => "GW2AR-18C",
            IDIV_SEL => 8,
            FBDIV_SEL => 31,
            ODIV_SEL => 8,
            DYN_SDIV_SEL => 2,
            PSDA_SEL => "1000"          -- 180 degree phase shift
        )
        port map (
            CLKIN    => sys_clk,
            CLKOUT   => clock_96,       -- 96MHz clock for SDRAM
            CLKOUTP  => clock_96_p,     -- 96MHz clock for SDRAM, phase shifted 180 degrees
            CLKOUTD  => clock_48,       -- 48MHz main clock
            CLKOUTD3 => open,
            LOCK     => open,
            RESET    => '0',
            RESET_P  => '0',
            CLKFB    => '0',
            FBDSEL   => (others => '0'),
            IDSEL    => (others => '0'),
            ODSEL    => (others => '0'),
            PSDA     => (others => '0'),
            DUTYDA   => (others => '0'),
            FDLY     => (others => '0')
        );


    --------------------------------------------------------
    -- Button 1: Power Up Reset and Master/Beeb toggle
    --------------------------------------------------------

    -- Generate a reliable power up reset on powerup, and if bt1n is pressed
    -- Also, if both IncludeMaster and IncludeBeeb then toggle m128mode

    reset_gen : process(clock_48)
    begin
        if rising_edge(clock_48) then
            if (btn1 = '1') then
                reset_counter <= (others => '0');
            elsif (reset_counter(reset_counter'high) = '0') then
                reset_counter <= reset_counter + 1;
            elsif powerup_reset_n = '0' then
                if IncludeBeeb and IncludeMaster then
                    m128_mode <= not m128_mode;
                elsif IncludeMaster then
                    m128_mode <= '1';
                else
                    m128_mode <= '0';
                end if;
            end if;
            powerup_reset_n <= reset_counter(reset_counter'high);
            hard_reset_n <= not (not powerup_reset_n or not mem_ready);
        end if;
    end process;

    --------------------------------------------------------
    -- Button 2: HDMI / DVI mode toggle
    --------------------------------------------------------

    config_gen : process(clock_48)
    begin
        if rising_edge(clock_48) then
            if powerup_reset_n = '0' then
                config_counter <= (others => '0');
            elsif btn2 = '1' then
                config_counter <= (others => '1');
            elsif config_counter(config_counter'high) = '1' then
                config_counter <= config_counter - 1;
            elsif config_last = '1' then

            end if;
            config_last <= config_counter(config_counter'high);
        end if;
    end process;

    --------------------------------------------------------
    -- Audio DACs
    --------------------------------------------------------

    -- Convert from signed to unsigned
    dac_l_in <= (not audio_l(15)) & audio_l(14 downto 6);
    dac_r_in <= (not audio_r(15)) & audio_r(14 downto 6);

    dac_l : entity work.pwm_sddac
        generic map (
            msbi_g => 9
        )
        port map (
            clk_i => clock_48,
            reset => '0',
            dac_i => dac_l_in,
            dac_o => audiol
        );

    dac_r : entity work.pwm_sddac
        generic map (
            msbi_g => 9
        )
        port map (
            clk_i => clock_48,
            reset => '0',
            dac_i => dac_r_in,
            dac_o => audior
        );


    --------------------------------------------------------
    -- PSRAM Memory Controller
    --------------------------------------------------------

    e_mem: entity work.mem_tang_20k
        generic map (
            SIM => SIM,
            IncludeMonitor => IncludeMonitor,
            IncludeBlockMOSBAS => not IncludeBootStrap,
            IncludeMinimalBeeb => true,
            IncludeMinimalMaster => false,
            PRJ_ROOT => PRJ_ROOT,
            MOS_NAME => MOS_NAME
        )
        port map (
            m128_mode      => m128_mode,
            RST_n          => powerup_reset_n,
            READY          => mem_ready,
            CLK_96         => clock_96,
            CLK_96_p       => clock_96_p,
            CLK_48         => clock_48,
            core_stb       => '0',
            core_A_stb     => ext_A_stb,
            core_A         => ext_A,
            core_Din       => ext_Din,
            core_Dout      => ext_Dout,
            core_nCS       => ext_nCS,
            core_nWE       => ext_nWE,
            core_nWE_long  => ext_nWE_long,
            core_nOE       => ext_nOE,

            O_sdram_clk    => O_sdram_clk     ,
            O_sdram_cke    => O_sdram_cke     ,
            O_sdram_cs_n   => O_sdram_cs_n    ,
            O_sdram_cas_n  => O_sdram_cas_n   ,
            O_sdram_ras_n  => O_sdram_ras_n   ,
            O_sdram_wen_n  => O_sdram_wen_n   ,
            IO_sdram_dq    => IO_sdram_dq     ,
            O_sdram_addr   => O_sdram_addr    ,
            O_sdram_ba     => O_sdram_ba      ,
            O_sdram_dqm    => O_sdram_dqm     ,

            led            => monitor_leds,

            FLASH_CS       => flash_cs,
            FLASH_SI       => flash_si,
            FLASH_CK       => flash_ck,
            FLASH_SO       => flash_so
        );

    

    --------------------------------------------------------
    -- Output Assignments
    --------------------------------------------------------

    -- gpio <= audiol & audior & trace_rstn & trace_phi2 & trace_sync & trace_r_nw & trace_data;

    -- gpio <= audiol & audior & trace_rstn & trace_phi2 & trace_sync & trace_r_nw & not clock_48 & pll1_lock & not clock_27 & pll2_lock & hsync_ref & clkdiv_reset_n & "00";

    led <= monitor_leds when IncludeMonitor else
           not caps_led & not shift_led & "1111";


    --------------------------------------------------------
    -- 1 bit video
    --------------------------------------------------------
    
    e_pll2: entity work.pll2v
    port map (
        clkout => i_clk_216,
        clkin => sys_clk
    );


    vid_cs_o <= not (i_VGA_hs xor i_VGA_vs); 

    p_v1:process(clock_48)
    begin
        if rising_edge(clock_48) then
            if i_VGA_CLKEN = '1' then
                vid_r_r <= unsigned(i_VGA_R);
                vid_g_r <= unsigned(i_VGA_G);
                vid_b_r <= unsigned(i_VGA_B);
                if vid_req = '1' then
                    vid_req <= '0';
                else
                    vid_req <= '1';
                end if;
            end if;
        end if;
    end process;

    p_v2:process(i_clk_216)
    variable v_vr2 : std_logic;
    begin
        if rising_edge(i_clk_216) then
            if v_vr2 /= vid_ack then
                vid_r_r2 <= vid_r_r;
                vid_g_r2 <= vid_g_r;
                vid_b_r2 <= vid_b_r;
                if vid_ack = '1' then
                    vid_ack <= '0';
                else
                    vid_ack <= '1';
                end if;
            end if;
            v_vr2 := vid_req;
        end if;
    end process;

    e_vidr:entity work.dac_1bit
    generic map (
        G_SAMPLE_SIZE       => 4,
        G_SYNC_DEPTH        => 1,
        G_PWM               => FALSE
    )
    port map (
        rst_i               => not hard_reset_n,
        clk_dac             => i_clk_216,

        sample              => vid_r_r2,
        
        bitstream           => vid_r_o
    );

    e_vidg:entity work.dac_1bit
    generic map (
        G_SAMPLE_SIZE       => 4,
        G_SYNC_DEPTH        => 1,
        G_PWM               => FALSE
    )
    port map (
        rst_i               => not hard_reset_n,
        clk_dac             => i_clk_216,

        sample              => vid_g_r2,
        
        bitstream           => vid_g_o
    );

    e_vidb:entity work.dac_1bit
    generic map (
        G_SAMPLE_SIZE       => 4,
        G_SYNC_DEPTH        => 1,
        G_PWM               => FALSE
    )
    port map (
        rst_i               => not hard_reset_n,
        clk_dac             => i_clk_216,

        sample              => vid_b_r2,
        
        bitstream           => vid_b_o
    );


    p_chrom:process(clock_48)
    constant div : natural := 105;
    constant num : natural := 704;    -- these are very rough, without 25Hz PAL freq offset
    variable r_acc : unsigned(numbits(num)-1 downto 0) := (others => '0');
    variable r_o : std_logic := '0';
    begin
        if rising_edge(clock_48) then
            r_acc := r_acc + div;
            if r_acc >= num then
                r_acc := r_acc - num;
                vid_chr_o <= r_o;
                r_o := not r_o;                
            end if;
        end if;

    end process;

end architecture;
