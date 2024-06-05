-- BBC Master / BBC B for the Tang Nano 9K
--
-- Copright (c) 2024 Dominic Beesley
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

entity bbc_micro_tang_primer25k is
    generic (
        IncludeMaster      : boolean := false; -- if both included, the CPU is the AlanD 65C02
        IncludeBeeb        : boolean := true; -- and btn1 can toggle between the ROM images

        IncludeAMXMouse    : boolean := false;
        IncludeSPISD       : boolean := true;
        IncludeSID         : boolean := true;
        IncludeMusic5000   : boolean := false; -- doesn't meet timing, but seems to work
        IncludeVideoNuLA   : boolean := false;
        IncludeTrace       : boolean := false;
        IncludeHDMI        : boolean := true;
        IncludeBootStrap   : boolean := true;
        IncludeBootstrapAndBlock : boolean := false; -- when true includes the OS/rom in MOS_NAME in slot 4, slot 3
        IncludeMonitor     : boolean := false;

        PRJ_ROOT           : string  := "../../..";
        MOS_NAME           : string  := "/roms/bbcb/os12_basic.bit";
        SIM                : boolean := false
        );
    port (
        board_clk50     : in    std_logic;
        btn1            : in    std_logic;     -- Toggle Master / Beeb modes
        btn2            : in    std_logic;     -- Toggle HDMI / DVI modes

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
        tf_uk_dat1      : inout std_logic;
        tf_uk_dat2      : inout std_logic;

        -- USB UART
        uart_rx         : in    std_logic;
        uart_tx         : out   std_logic;

        -- HDMI
        tmds_clk_p      : out   std_logic;
        tmds_clk_n      : out   std_logic;
        tmds_d_p        : out   std_logic_vector(2 downto 0);
        tmds_d_n        : out   std_logic_vector(2 downto 0);

        -- sdram interface
        sdram_clk_o         :  out  std_logic;
        sdram_DQ_io         :   inout std_logic_vector(15 downto 0);
        sdram_A_o           :   out std_logic_vector(12 downto 0); 
        sdram_BS_o          :  out  std_logic_vector(1 downto 0); 
        --sdram_CKE_o         :   out std_logic;
        sdram_nCS_o         :   out std_logic;
        sdram_nRAS_o        :   out std_logic;
        sdram_nCAS_o        :   out std_logic;
        sdram_nWE_o         :   out std_logic;
        sdram_DQM_o         :   out std_logic_vector(1 downto 0);

        -- SPI Flash (for ROM data)
        flash_cs        : out   std_logic;     -- Active low FLASH chip select
        flash_si        : out   std_logic;     -- Serial output to FLASH chip SI pin
        flash_ck        : out   std_logic;     -- FLASH clock
        flash_so        : in    std_logic;     -- Serial input from FLASH chip SO pin
        flash_uk_wp     : inout std_logic;
        flash_uk_hold   : inout std_logic;

        debug_sync      : out std_logic;
        debug_vid       : out std_logic;

        test_o          : out std_logic_vector(1 downto 0);
        brd_led_o       : out std_logic_vector(1 downto 0)
        );
end entity;

architecture rtl of bbc_micro_tang_primer25k is

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

    component CLKDIV
        generic (
            DIV_MODE : string := "2";
            GSREN: in string := "false"
        );
        port (
            CLKOUT: out std_logic;
            HCLKIN: in std_logic;
            RESETN: in std_logic;
            CALIB: in std_logic
        );
    end component;

    component OSER10
        port (
            Q : out std_logic;
            D0 : in std_logic;
            D1 : in std_logic;
            D2 : in std_logic;
            D3 : in std_logic;
            D4 : in std_logic;
            D5 : in std_logic;
            D6 : in std_logic;
            D7 : in std_logic;
            D8 : in std_logic;
            D9 : in std_logic;
            FCLK : in std_logic;
            PCLK : in std_logic;
            RESET : in std_logic
        );
    end component;

    component ELVDS_OBUF
        port (
            I : in std_logic;
            O : out std_logic;
            OB : out std_logic
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
    signal clock_135       : std_logic;
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
    signal reset_counter   : std_logic_vector(RESETBITS downto 0) := (others => '0');

    signal ext_A_stb       : std_logic;
    signal ext_stb         : std_logic;
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


    -- HDMI
    signal hdmi_aspect     : std_logic_vector(1 downto 0);
    signal hdmi_audio_en   : std_logic;
    signal vid_debug       : std_logic;
    signal tmds_r          : std_logic_vector(9 downto 0);
    signal tmds_g          : std_logic_vector(9 downto 0);
    signal tmds_b          : std_logic_vector(9 downto 0);

    -- CPU tracing
    signal trace_data      :   std_logic_vector(7 downto 0);
    signal trace_r_nw      :   std_logic;
    signal trace_sync      :   std_logic;
    signal trace_rstn      :   std_logic;
    signal trace_phi2      :   std_logic;

    -- Mem Controller Monior LEDs
    signal monitor_leds    :   std_logic_vector(5 downto 0);

    signal i_test           : std_logic_vector(7 downto 0);

begin
    -- unused pins --
    tf_uk_dat1 <= 'Z';
    tf_uk_dat2 <= 'Z';

    flash_uk_wp <= '0';
    flash_uk_hold <= '1';

    debug_sync <= i_VGA_HS xor i_VGA_VS;
    debug_vid  <= or_reduce(i_VGA_R);

    test_o         <= i_test(1 downto 0);
    brd_led_o      <= hard_reset_n & powerup_reset_n;

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
            clock_27       => clock_27,
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
            video_hsync    => i_VGA_HS,
            video_vsync    => i_VGA_VS,
            audio_l        => audio_l,
            audio_r        => audio_r,
            ext_nOE        => ext_nOE,
            ext_nWE        => ext_nWE,
            ext_nWE_long   => ext_nWE_long,
            ext_nCS        => ext_nCS,
            ext_A          => ext_A,
            ext_A_stb      => ext_A_stb,
            ext_stb        => ext_stb,
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
            hdmi_aspect    => hdmi_aspect,
            hdmi_audio_en  => hdmi_audio_en,
            vid_debug      => vid_debug,
            tmds_r         => tmds_r,
            tmds_g         => tmds_g,
            tmds_b         => tmds_b,
            trace_data     => trace_data,
            trace_r_nw     => trace_r_nw,
            trace_sync     => trace_sync,
            trace_rstn     => trace_rstn,
            trace_phi2     => trace_phi2,
            test           => i_test
        );

    vid_mode       <= "0001" when IncludeHDMI else "0000";
    keyb_dip       <= "00000000";
    hdmi_aspect    <= "00";
    vid_debug      <= '0';

    --------------------------------------------------------
    -- Clock Generation
    --------------------------------------------------------

    -- pll_27_135 generates the 27/135 clock for HDMI and video
    e_pll_27_135: entity work.pll_27_135
    port map (
        lock        => open,
        clkout0     => clock_27,            -- pixel clock
        clkout1     => clock_135,           -- hdmi serial clock
        clkin       => board_clk50
    );


    e_pll_48_96: entity work.pll_48_96
    port map (
        lock        => open,
        clkout0     => clock_48,            -- core clock
        clkout1     => clock_96,            -- sdram controller clock
        clkout2     => clock_96_p,          -- sdram memory chips clock, phase shifted 
        clkin       => clock_27
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
                hdmi_audio_en <= '1';
                config_counter <= (others => '0');
            elsif btn2 = '1' then
                config_counter <= (others => '1');
            elsif config_counter(config_counter'high) = '1' then
                config_counter <= config_counter - 1;
            elsif config_last = '1' then
                hdmi_audio_en <= not hdmi_audio_en;
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
    -- HDMI Output
    --------------------------------------------------------

    --  Serialize the three 10-bit TMDS channels to three serialized 1-bit TMDS streams

    hdmi : if (IncludeHDMI) generate
        signal serialized_c : std_logic;
        signal serialized_r : std_logic;
        signal serialized_g : std_logic;
        signal serialized_b : std_logic;
    begin

        ser_b : OSER10
            port map(
                PCLK  => clock_27,
                FCLK  => clock_135,
                RESET => '0',
                Q     => serialized_b,
                D0    => tmds_b(0),
                D1    => tmds_b(1),
                D2    => tmds_b(2),
                D3    => tmds_b(3),
                D4    => tmds_b(4),
                D5    => tmds_b(5),
                D6    => tmds_b(6),
                D7    => tmds_b(7),
                D8    => tmds_b(8),
                D9    => tmds_b(9)
            );

        ser_g : OSER10
            port map (
                PCLK  => clock_27,
                FCLK  => clock_135,
                RESET => '0',
                Q     => serialized_g,
                D0    => tmds_g(0),
                D1    => tmds_g(1),
                D2    => tmds_g(2),
                D3    => tmds_g(3),
                D4    => tmds_g(4),
                D5    => tmds_g(5),
                D6    => tmds_g(6),
                D7    => tmds_g(7),
                D8    => tmds_g(8),
                D9    => tmds_g(9)
            );

        ser_r : OSER10
            port map (
                PCLK  => clock_27,
                FCLK  => clock_135,
                RESET => '0',
                Q     => serialized_r,
                D0    => tmds_r(0),
                D1    => tmds_r(1),
                D2    => tmds_r(2),
                D3    => tmds_r(3),
                D4    => tmds_r(4),
                D5    => tmds_r(5),
                D6    => tmds_r(6),
                D7    => tmds_r(7),
                D8    => tmds_r(8),
                D9    => tmds_r(9)
                );

        ser_c : OSER10
            port map (
                PCLK  => clock_27,
                FCLK  => clock_135,
                RESET => '0',
                Q     => serialized_c,
                D0    => '1',
                D1    => '1',
                D2    => '1',
                D3    => '1',
                D4    => '1',
                D5    => '0',
                D6    => '0',
                D7    => '0',
                D8    => '0',
                D9    => '0'
            );

        -- Encode the 1-bit serialized TMDS streams to Low-voltage differential signaling (LVDS) HDMI output pins

        OBUFDS_c : ELVDS_OBUF
            port map (
                I  => serialized_c,
                O  => tmds_clk_p,
                OB => tmds_clk_n
             );

        OBUFDS_b : ELVDS_OBUF
            port map (
                I  => serialized_b,
                O  => tmds_d_p(0),
                OB => tmds_d_n(0)
            );

        OBUFDS_g : ELVDS_OBUF
            port map (
                I  => serialized_g,
                O  => tmds_d_p(1),
                OB => tmds_d_n(1)
            );

        OBUFDS_r : ELVDS_OBUF
            port map (
                I  => serialized_r,
                O  => tmds_d_p(2),
                OB => tmds_d_n(2)
            );

    end generate;

    --------------------------------------------------------
    -- SDRAM Memory Controller
    --------------------------------------------------------

    sdram_clk_o <= clock_96_p;

    e_mem: entity work.mem_tang_25k
        generic map (
            SIM => SIM,
            IncludeMonitor => IncludeMonitor,
            IncludeBootStrap => IncludeBootStrap,
            IncludeBootstrapAndBlock => IncludeBootstrapAndBlock,
            IncludeMinimalBeeb => true,
            IncludeMinimalMaster => false,
            PRJ_ROOT => PRJ_ROOT,
            MOS_NAME => MOS_NAME
        )
        port map (
            m128_mode      => m128_mode,
            CLK_96         => clock_96,
            CLK_96_P       => clock_96_p,
            RST_n          => powerup_reset_n,
            READY          => mem_ready,
            CLK_48         => clock_48,
            core_A_stb     => ext_A_stb,
            core_stb       => ext_stb,
            core_A         => ext_A,
            core_Din       => ext_Din,
            core_Dout      => ext_Dout,
            core_nCS       => ext_nCS,
            core_nWE       => ext_nWE,
            core_nWE_long  => ext_nWE_long,
            core_nOE       => ext_nOE,

            -- sdram interface
            sdram_DQ_io     => sdram_DQ_io,
            sdram_A_o       => sdram_A_o,
            sdram_BS_o      => sdram_BS_o,
            sdram_CKE_o     => open, --sdram_CKE_o,
            sdram_nCS_o     => sdram_nCS_o,
            sdram_nRAS_o    => sdram_nRAS_o,
            sdram_nCAS_o    => sdram_nCAS_o,
            sdram_nWE_o     => sdram_nWE_o,
            sdram_DQM_o     => sdram_DQM_o,


            led            => monitor_leds,

            FLASH_CS       => flash_cs,
            FLASH_SI       => flash_si,
            FLASH_CK       => flash_ck,
            FLASH_SO       => flash_so
        );


end architecture;
