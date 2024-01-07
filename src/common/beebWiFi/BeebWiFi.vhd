----------------------------------------------------------------------------------
-- Company:
-- Engineer: Dominic Beesley
--
-- Create Date:    01/02/2024
-- Design Name:
-- Module Name:    BeebWiFi - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BeebWifi is
    generic (
        -- id is the value that must be written to &FCFF to unlock 
        --    the JIM interface
        id       : std_logic_vector(7 downto 0) := x"A0";
        fred_base: std_logic_vector(7 downto 4) := x"5" -- base address in fred workspace (top nybble)
    );
    port (
        -- This is the cpu clock
        clk      : in     std_logic;
        clken    : in     std_logic;
        rnw      : in     std_logic;
        rst_n    : in     std_logic;
        pgfc_n   : in     std_logic;
        pgfd_n   : in     std_logic;
        a        : in     std_logic_vector (7 downto 0);
        din      : in     std_logic_vector (7 downto 0);
        dout     : out    std_logic_vector (7 downto 0);
        dout_oel : out    std_logic;
        
        jimsel   : out    std_logic;
        jimpage  : out    std_logic_vector(8 downto 0);

        esp_rx_i        : in     std_logic;
        esp_tx_o        : out    std_logic;
        bwifi_clk_brg_i : in     std_logic;

        esp_cts_n_o     : out    std_logic;
        esp_rts_n_i     : in     std_logic

    );
end BeebWifi;

architecture Behavioral of BeebWifi is

-- bits of address fcff
signal r_jimsel     : std_logic;                         -- when '1' jim interface is selected
signal r_page       : std_logic_vector(8 downto 0);      -- jim page
signal i_uart_dout  : std_logic_vector(7 downto 0);
signal i_uart_cs    : std_logic;

begin

    jimsel <= r_jimsel;
    jimpage <= r_page;

    ------------------------------------------------
    -- Bus Interface
    ------------------------------------------------

    bus_interface_fc : process(clk)
    begin
        if rst_n = '0' then
            r_jimsel <= '0';
            r_page <= (others => '0');
        elsif rising_edge(clk) then
            if clken = '1' and rnw = '0' and pgfc_n = '0' then
                if a = x"FF" then
                    if (din(7 downto 0) = id) then
                        r_jimsel <= '1';
                    else
                        r_jimsel <= '0';
                    end if;
                elsif r_jimsel = '1' and a = x"FE" then
                    r_page(7 downto 0) <= din;
                elsif r_jimsel = '1' and a = x"FD" then
                    r_page(8) <= din(0);
                end if;

            end if;
        end if;
    end process;

    reg_rd : process(rnw, a, pgfc_n, r_jimsel, r_page, i_uart_dout)
    begin
        dout_oel <= '1';
        dout <= (others => '0');
        if rnw = '1' and pgfc_n = '0' then
            if a = x"FF" and r_jimsel = '1' then
                -- device select register
                dout_oel <= '0';
                dout <= id xor x"FF";
            elsif a = x"FE" and r_jimsel = '1' then
            --TODO: do we need readback for paging registers, delete if not
                dout_oel <= '0';
                dout <= r_page(7 downto 0);
            elsif a = x"FD" and r_jimsel = '1' then
            --TODO: do we need readback for paging registers, delete if not
                dout_oel <= '0';
                dout <= "0000000" & r_page(8);
            elsif a(7 downto 3) = fred_base & '0' then
                dout_oel <= '0';
                dout <= i_uart_dout;
            end if;
        end if;
    end process;

    i_uart_cs <= '1' when pgfc_n = '0' and a(7 downto 3) = fred_base & '0' and clken = '1' else
                 '0';

    e_uart:entity work.gh_uart_16550
    port map (
        clk         => clk,
        BR_clk      => bwifi_clk_brg_i,
        rst         => not rst_n,
        rst_buffer  => not rst_n,
        CS          => i_uart_cs,                       -- Chip select -> 1 Cycle long CS strobe = 1 data send
        WR          => not rnw,                         -- WRITE when HIGH with CS high | READ when LOW with CS high  
        ADD         => a(2 downto 0),                   -- Address bus
        D           => din,                             -- Input DATA BUS
        RD          => i_uart_dout,                     -- Output DATA BUS
        
        sRX         => esp_rx_i,
        CTSn        => '1',
        DSRn        => '1',
        RIn         => '1',
        DCDn        => '1',
        
        sTX         => esp_tx_o,                        -- uart's OUTPUT
        DTRn        => open,
        RTSn        => open,
        OUT1n       => open,
        OUT2n       => open,
        TXRDYn      => open,
        RXRDYn      => open,
        
        IRQ         => open,
        B_CLK       => open                        -- 16x Baudrate clock output
        );


    esp_cts_n_o <= '0';

end Behavioral;
