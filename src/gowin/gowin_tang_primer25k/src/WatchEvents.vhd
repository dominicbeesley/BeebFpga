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
begin

	e_fifo:watch_events_int
	port map (
		Data		=>	din,
		Clk			=>  clk,
		WrEn		=>  wr_en,
		RdEn		=>  rd_en,
		Q			=>  dout,
		Empty		=>  empty,
		Full		=>  full,
		Reset		=>  srst
	);

end rtl;
