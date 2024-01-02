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
        id       : std_logic_vector(7 downto 0) := x"A0"
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
        jimpage  : out    std_logic_vector(8 downto 0)

    );
end BeebWifi;

architecture Behavioral of BeebWifi is

-- bits of address fcff
signal r_jimsel : std_logic;                         -- when '1' jim interface is selected
signal r_page   : std_logic_vector(8 downto 0);      -- jim page

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

    reg_rd : process(rnw, a, pgfd_n, pgfc_n, r_jimsel, r_page)
    begin
        dout_oel <= '1';
        dout <= (others => '0');
        if rnw = '1' then
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
            end if;
        end if;
    end process;



end Behavioral;
