--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.9.02
--Part Number: GW5A-LV25MG121NC2/I1
--Device: GW5A-25
--Device Version: A
--Created Time: Sun Jun  9 23:32:41 2024

--Change the instance name and port connections to the signal names
----------Copy here to design--------

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

your_instance_name: watch_events_int
	port map (
		Data => Data_i,
		Clk => Clk_i,
		WrEn => WrEn_i,
		RdEn => RdEn_i,
		Reset => Reset_i,
		Q => Q_o,
		Empty => Empty_o,
		Full => Full_o
	);

----------Copy end-------------------
