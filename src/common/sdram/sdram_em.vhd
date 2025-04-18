--------------------------------------------------------------------------------
-- Copyright (c) 2015-2025 David Banks
-- Copyright (c) 2025 Dominic Beesley
--------------------------------------------------------------------------------

-- wrapper to translate bbc micro core external memory signals to sdram controller signals


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use ieee.math_real.all;

library work;
use work.common.all;
use work.ext_mem_pack.all;

entity sdram_em is
generic (

    CLOCKSPEED  : natural;
    T_CAS_EXTRA : natural; -- this needs to be 1 for > ~90 MHz

    -- SDRAM geometry
    LANEBITS    : natural; -- number of byte lanes bits, if 0 don't connect sdram_DQM_o
    BANKBITS    : natural; -- number of bits, if none set to 0 and don't connect sdram_BS_o
    ROWBITS     : positive;
    COLBITS     : positive;

    -- SDRAM speed 
    trp         : time;  -- precharge
    trcd        : time;  -- active to read/write
    trc         : time;  -- active to active time
    trfsh       : time;  -- the refresh control signal will be blocked if it occurs more frequently than this
    trfc        : time   -- refresh cycle time
);
port (

    CLK_96            : in  std_logic;
    CLK_96_P          : in  std_logic;
    CLK_48            : in  std_logic;

    rst_n             : in  std_logic;

    -- signals to/from core/bootstrapper
    em_c2m_i          : in  em_c2m_t;
    em_m2c_o          : out em_m2c_t;

    O_sdram_clk       : out   std_logic;
    O_sdram_cke       : out   std_logic;
    O_sdram_cs_n      : out   std_logic;
    O_sdram_cas_n     : out   std_logic;
    O_sdram_ras_n     : out   std_logic;
    O_sdram_wen_n     : out   std_logic;
    IO_sdram_dq       : inout std_logic_vector(31 downto 0);
    O_sdram_addr      : out   std_logic_vector(10 downto 0);
    O_sdram_ba        : out   std_logic_vector(1 downto 0);
    O_sdram_dqm       : out   std_logic_vector(3 downto 0)
);

end sdram_em;


architecture rtl of sdram_em is

    -- sdram controller
    signal i_sdram_cmd_read    : std_logic;
    signal i_sdram_cmd_write   : std_logic;
    signal i_sdram_cyc         : std_logic;
    signal i_sdram_we          : std_logic;
    signal i_sdram_addr        : std_logic_vector(22 downto 0);
    signal i_sdram_din         : std_logic_vector(7 downto 0);
    signal i_sdram_dout        : std_logic_vector(7 downto 0);
    signal i_sdram_busy        : std_logic;

begin


    sdram_ctl : entity work.sdramctl
    generic map (
        CLOCKSPEED  => CLOCKSPEED,
        T_CAS_EXTRA => T_CAS_EXTRA,

        -- SDRAM geometry
        LANEBITS    => LANEBITS,
        BANKBITS    => BANKBITS,
        ROWBITS     => ROWBITS,
        COLBITS     => COLBITS,

        -- SDRAM speed
        trp             => trp,
        trcd            => trcd,
        trc             => trc,
        trfsh           => trfsh,
        trfc            => trfc
    )
    port map (
        Clk          => CLK_96,

        sdram_DQ_io  => IO_sdram_dq,
        sdram_A_o    => O_sdram_addr,
        sdram_BS_o   => O_sdram_ba,
        sdram_CKE_o  => O_sdram_cke,
        sdram_nCS_o  => O_sdram_cs_n,
        sdram_nRAS_o => O_sdram_ras_n,
        sdram_nCAS_o => O_sdram_cas_n,
        sdram_nWE_o  => O_sdram_wen_n,
        sdram_DQM_o  => O_sdram_dqm,

        ctl_rfsh_i   => '0',
        ctl_reset_i  => not rst_n,
        ctl_stall_o  => em_m2c_o.busy,
        ctl_cyc_i    => i_sdram_cyc,
        ctl_we_i     => i_sdram_we,
        ctl_A_i      => i_sdram_addr,
        ctl_D_wr_i   => em_c2m_i.D,
        ctl_D_rd_o   => em_m2c_o.D,
        ctl_ack_o    => open
        );

    O_sdram_clk <= CLK_96_P;

    -- Controls for NESTang Controller
    i_sdram_cmd_read  <= not(em_c2m_i.nCS) and em_c2m_i.A_stb and not em_c2m_i.nOE;
    i_sdram_cmd_write <= not(em_c2m_i.nCS) and em_c2m_i.A_stb and not em_c2m_i.nWE_long;

    -- Controls for Dominic SDRAM Controller
    i_sdram_cyc  <= not(em_c2m_i.nCS) and em_c2m_i.A_stb;
    i_sdram_we   <= not em_c2m_i.nWE_long;

    -- SDRAM address is structured such that the low address lines drive the rows
    -- and provide a refresh (up to 10 bits provided by mode 7)

    p_a_map:process(all)

        function l_min(a:natural; b:natural) return natural is
        begin
            if a < b then
                return a;
            else
                return b;
            end if;
        end function;

    constant B_DQM_HI   : integer := LANEBITS - 1;  -- maybe < 0
    constant B_COL_LO   : natural := B_DQM_HI + 1;
    constant B_COL_HI   : natural := B_COL_LO + COLBITS - 1;
    constant B_ROW_LO   : natural := B_COL_HI + 1;
    constant B_ROW_HI   : natural := B_ROW_LO + ROWBITS - 1;
    constant B_BANK_LO  : natural := B_ROW_HI + 1;
    constant B_BANK_HI  : natural := B_BANK_LO + BANKBITS - 1;

    constant B_USE_ROWS         : natural := l_min(10, ROWBITS);       -- if more than 10 row bits they won't get refreshed so don't use!
    constant B_USE_COLSANDLANES : natural := l_min(EXT_MEM_A_WIDTH-B_USE_ROWS, COLBITS+LANEBITS); -- shove rest in columns
    constant B_USE_BANKS        : natural := EXT_MEM_A_WIDTH-B_USE_ROWS-B_USE_COLSANDLANES;

    begin
        i_sdram_addr <= (others => '0');
        i_sdram_addr(B_ROW_LO+B_USE_ROWS-1 downto B_ROW_LO) <= em_c2m_i.A(B_USE_ROWS-1 downto 0);
        i_sdram_addr(B_USE_COLSANDLANES-1 downto 0) <= em_c2m_i.A(B_USE_ROWS+B_USE_COLSANDLANES-1 downto B_USE_ROWS);
        if B_USE_BANKS > 0 then
            i_sdram_addr(B_USE_BANKS+B_BANK_LO-1 downto B_BANK_LO) <= em_c2m_i.A(B_USE_ROWS+B_USE_COLSANDLANES+B_USE_BANKS-1 downto B_USE_ROWS+B_USE_COLSANDLANES);
        end if;
    end process;



end rtl;
