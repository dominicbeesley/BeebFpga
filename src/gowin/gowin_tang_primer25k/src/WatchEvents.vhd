--------------------------------------------------------------------------------
-- Copyright (c) 2024 Dominic Beesley, David Banks
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
library work;
entity WatchEvents is
  port (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(71 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(71 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
end WatchEvents;

architecture rtl of WatchEvents is
	component watch_events_int
	port (
		Data: in std_logic_vector(71 downto 0);
		Clk: in std_logic;
		WrEn: in std_logic;
		RdEn: in std_logic;
		Reset: in std_logic;
		Q: out std_logic_vector(71 downto 0);
		Empty: out std_logic;
		Full: out std_logic
	);
	end component;

	signal r_occup : std_logic := '0';
	signal r_data  : std_logic_vector(71 downto 0);
begin

--	p_fif:process(clk)
--	begin
--		if rising_edge(clk) then
--			if srst = '1' then
--				r_occup <= '0';
--			else
--				if rd_en = '1' and r_occup = '1' then
--					r_occup <= '0';
----					dout <= r_data;
--				end if;
--
--				if wr_en = '1' and r_occup = '0' then
--					r_data <= din;
--					r_occup <= '1';
--				end if;
--
--			end if;
--
--		end if;
--
--	end process;
--
--	dout <= r_data;
--	empty <= not r_occup;
--	full <= r_occup;


	dout <= din;

end rtl;
