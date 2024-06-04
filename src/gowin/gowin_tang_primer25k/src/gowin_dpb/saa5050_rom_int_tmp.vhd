--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.9.02
--Part Number: GW5A-LV25MG121NC1/I0
--Device: GW5A-25
--Device Version: B
--Created Time: Sun Jun  2 19:57:56 2024

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component saa5050_rom_int
    port (
        douta: out std_logic_vector(7 downto 0);
        doutb: out std_logic_vector(7 downto 0);
        clka: in std_logic;
        ocea: in std_logic;
        cea: in std_logic;
        reseta: in std_logic;
        wrea: in std_logic;
        clkb: in std_logic;
        oceb: in std_logic;
        ceb: in std_logic;
        resetb: in std_logic;
        wreb: in std_logic;
        ada: in std_logic_vector(11 downto 0);
        dina: in std_logic_vector(7 downto 0);
        adb: in std_logic_vector(11 downto 0);
        dinb: in std_logic_vector(7 downto 0)
    );
end component;

your_instance_name: saa5050_rom_int
    port map (
        douta => douta_o,
        doutb => doutb_o,
        clka => clka_i,
        ocea => ocea_i,
        cea => cea_i,
        reseta => reseta_i,
        wrea => wrea_i,
        clkb => clkb_i,
        oceb => oceb_i,
        ceb => ceb_i,
        resetb => resetb_i,
        wreb => wreb_i,
        ada => ada_i,
        dina => dina_i,
        adb => adb_i,
        dinb => dinb_i
    );

----------Copy end-------------------
