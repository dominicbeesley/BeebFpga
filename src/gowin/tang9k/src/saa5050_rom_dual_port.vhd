library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity saa5050_rom_dual_port is
    generic (
        ADDR_WIDTH       : integer := 12;
        DATA_WIDTH       : integer := 8
        );
    port(
        clock    : in  std_logic;
        addressA : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        QA       : out std_logic_vector(DATA_WIDTH-1 downto 0);
        addressB : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        QB       : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
end saa5050_rom_dual_port;

architecture RTL of saa5050_rom_dual_port is


    component DPB
        generic (
            READ_MODE0: in bit := '0';
            READ_MODE1: in bit := '0';
            WRITE_MODE0: in bit_vector := "00";
            WRITE_MODE1: in bit_vector := "00";
            BIT_WIDTH_0: in integer :=16;
            BIT_WIDTH_1: in integer :=16;
            BLK_SEL_0: in bit_vector := "000";
            BLK_SEL_1: in bit_vector := "000";
            RESET_MODE: in string := "SYNC";
            INIT_RAM_00: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_01: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_02: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_03: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_04: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_05: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_06: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_07: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_08: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_09: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_10: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_11: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_12: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_13: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_14: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_15: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_16: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_17: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_18: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_19: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_20: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_21: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_22: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_23: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_24: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_25: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_26: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_27: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_28: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_29: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_30: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_31: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_32: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_33: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_34: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_35: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_36: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_37: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_38: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_39: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000"
            );
        port (
            DOA: out std_logic_vector(15 downto 0);
            DOB: out std_logic_vector(15 downto 0);
            CLKA: in std_logic;
            OCEA: in std_logic;
            CEA: in std_logic;
            RESETA: in std_logic;
            WREA: in std_logic;
            CLKB: in std_logic;
            OCEB: in std_logic;
            CEB: in std_logic;
            RESETB: in std_logic;
            WREB: in std_logic;
            BLKSELA: in std_logic_vector(2 downto 0);
            BLKSELB: in std_logic_vector(2 downto 0);
            ADA: in std_logic_vector(13 downto 0);
            DIA: in std_logic_vector(15 downto 0);
            ADB: in std_logic_vector(13 downto 0);
            DIB: in std_logic_vector(15 downto 0)
            );
    end component;

    signal doa_upper : std_logic_vector(15 downto 0);
    signal doa_lower : std_logic_vector(15 downto 0);
    signal dob_upper : std_logic_vector(15 downto 0);
    signal dob_lower : std_logic_vector(15 downto 0);

begin

    rom_low: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "10",
            WRITE_MODE1 => "10",
            BIT_WIDTH_0 => 4,
            BIT_WIDTH_1 => 4,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "000",
            BLK_SEL_1 => "000",
            INIT_RAM_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_08 => X"00000000F88C8960000000000000AAA000000000404444400000000000000000",
            INIT_RAM_09 => X"000000000000444000000000D2584480000000003384298000000000E55E45E0",
            INIT_RAM_0A => X"00000000044F44000000000045E4E54000000000842224800000000024888420",
            INIT_RAM_0B => X"0000000000842100000000004000000000000000000E00000000000844000000",
            INIT_RAM_0C => X"00000000E11621F000000000F08611E000000000E4444C40000000004A111A40",
            INIT_RAM_0D => X"00000000888421F000000000E11E086000000000E111E0F00000000022F2A620",
            INIT_RAM_0E => X"0000000844004000000000004000400000000000C21F11E000000000E11E11E0",
            INIT_RAM_0F => X"00000000404421E000000000842124800000000000F0F0000000000024808420",
            INIT_RAM_10 => X"00000000E10001E000000000E11E11E00000000011F11A4000000000E07571E0",
            INIT_RAM_11 => X"00000000F13001E000000000000E00F000000000F00E00F000000000E11111E0",
            INIT_RAM_12 => X"000000001248421000000000E111111000000000E44444E000000000111F1110",
            INIT_RAM_13 => X"00000000E11111E000000000113591100000000011155B1000000000F0000000",
            INIT_RAM_14 => X"00000000E11E01E000000000124E11E000000000D25111E000000000000E11E0",
            INIT_RAM_15 => X"00000000A55511100000000044AA111000000000E111111000000000444444F0",
            INIT_RAM_16 => X"00000000048F840000000000F08421F0000000004444A1100000000011A4A110",
            INIT_RAM_17 => X"00000000AAFAFAA0000000000445E40000000000042F24000000007421600000",
            INIT_RAM_18 => X"00000000F000F00000000000E111E00000000000F1F1E00000000000000F0000",
            INIT_RAM_19 => X"000000E1F111F00000000000444E442000000000E0F1E00000000000F111F110",
            INIT_RAM_1A => X"000000009ACA9880000000844444404000000000E444C040000000001111E000",
            INIT_RAM_1B => X"00000000E111E000000000001111E000000000005555A00000000000E44444C0",
            INIT_RAM_1C => X"00000000E1E0F00000000000888CB00000000011F111F00000000000E111E000",
            INIT_RAM_1D => X"00000000A5511000000000004AA1100000000000F1111000000000002444E440",
            INIT_RAM_1E => X"000000175398888000000000F842F000000000E1F1111000000000001A4A1000",
            INIT_RAM_1F => X"00000000FFFFFFF000000000040F0400000000175394848000000000AAAAAAA0",
            INIT_RAM_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_28 => X"0000000000000FFF000000000000077700000000000008880000000000000000",
            INIT_RAM_29 => X"0000000008888FFF000000000888877700000000088888880000000008888000",
            INIT_RAM_2A => X"0000000007777FFF000000000777777700000000077778880000000007777000",
            INIT_RAM_2B => X"000000000FFFFFFF000000000FFFF777000000000FFFF888000000000FFFF000",
            INIT_RAM_2C => X"0000008880000FFF000000888000077700000088800008880000008880000000",
            INIT_RAM_2D => X"0000008888888FFF000000888888877700000088888888880000008888888000",
            INIT_RAM_2E => X"0000008887777FFF000000888777777700000088877778880000008887777000",
            INIT_RAM_2F => X"000000888FFFFFFF000000888FFFF777000000888FFFF888000000888FFFF000",
            INIT_RAM_30 => X"00000000E10001E000000000E11E11E00000000011F11A4000000000E07571E0",
            INIT_RAM_31 => X"00000000F13001E000000000000E00F000000000F00E00F000000000E11111E0",
            INIT_RAM_32 => X"000000001248421000000000E111111000000000E44444E000000000111F1110",
            INIT_RAM_33 => X"00000000E11111E000000000113591100000000011155B1000000000F0000000",
            INIT_RAM_34 => X"00000000E11E01E000000000124E11E000000000D25111E000000000000E11E0",
            INIT_RAM_35 => X"00000000A55511100000000044AA111000000000E111111000000000444444F0",
            INIT_RAM_36 => X"00000000048F840000000000F08421F0000000004444A1100000000011A4A110",
            INIT_RAM_37 => X"00000000AAFAFAA0000000000445E40000000000042F24000000007421600000",
            INIT_RAM_38 => X"0000007770000FFF000000777000077700000077700008880000007770000000",
            INIT_RAM_39 => X"0000007778888FFF000000777888877700000077788888880000007778888000",
            INIT_RAM_3A => X"0000007777777FFF000000777777777700000077777778880000007777777000",
            INIT_RAM_3B => X"000000777FFFFFFF000000777FFFF777000000777FFFF888000000777FFFF000",
            INIT_RAM_3C => X"000000FFF0000FFF000000FFF0000777000000FFF0000888000000FFF0000000",
            INIT_RAM_3D => X"000000FFF8888FFF000000FFF8888777000000FFF8888888000000FFF8888000",
            INIT_RAM_3E => X"000000FFF7777FFF000000FFF7777777000000FFF7777888000000FFF7777000",
            INIT_RAM_3F => X"000000FFFFFFFFFF000000FFFFFFF777000000FFFFFFF888000000FFFFFFF000"
            )
        port map (
            DOA => doa_lower,
            DOB => dob_lower,
            CLKA => clock,
            OCEA => '1',
            CEA => '1',
            RESETA => '0',
            WREA => '0',
            CLKB => clock,
            OCEB => '1',
            CEB => '1',
            RESETB => '0',
            WREB => '0',
            BLKSELA => "000",
            BLKSELB => "000",
            ADA => addressA & "00",
            DIA => (others => '0'),
            ADB => addressB & "00",
            DIB =>  (others => '0')
            );

    rom_high: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "10",
            WRITE_MODE1 => "10",
            BIT_WIDTH_0 => 4,
            BIT_WIDTH_1 => 4,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "000",
            BLK_SEL_1 => "000",
            INIT_RAM_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_08 => X"0000000010010000000000000000000000000000000000000000000000000000",
            INIT_RAM_09 => X"0000000000000000000000000110110000000000010001100000000001001100",
            INIT_RAM_0A => X"0000000000010000000000000100010000000000000000000000000000000000",
            INIT_RAM_0B => X"0000000001000000000000000000000000000000000000000000000000000000",
            INIT_RAM_0C => X"0000000001000010000000001100010000000000000000000000000000111000",
            INIT_RAM_0D => X"0000000000000010000000000111100000000000010011100000000000110000",
            INIT_RAM_0E => X"0000000000000000000000000000000000000000000011000000000001101100",
            INIT_RAM_0F => X"0000000000000100000000000000000000000000001010000000000000010000",
            INIT_RAM_10 => X"0000000001111100000000001111111000000000111110000000000001111100",
            INIT_RAM_11 => X"0000000001111100000000001111111000000000111111100000000011111110",
            INIT_RAM_12 => X"0000000011111110000000000100000000000000000000000000000011111110",
            INIT_RAM_13 => X"0000000001111100000000001111111000000000111111100000000011111110",
            INIT_RAM_14 => X"0000000001001100000000001111111000000000011111000000000011111110",
            INIT_RAM_15 => X"0000000001111110000000000000111000000000011111100000000000000010",
            INIT_RAM_16 => X"0000000000010000000000001100001000000000000001100000000011000110",
            INIT_RAM_17 => X"0000000000101000000000000001000000000000000100000000000000111110",
            INIT_RAM_18 => X"0000000001110000000000001111111000000000010000000000000000010000",
            INIT_RAM_19 => X"0000000001110000000000000000000000000000011100000000000001110000",
            INIT_RAM_1A => X"0000000000000000000000000000000000000000000000000000000011111110",
            INIT_RAM_1B => X"0000000001110000000000001111100000000000111110000000000000000000",
            INIT_RAM_1C => X"0000000010010000000000000000000000000000011100000000001111111000",
            INIT_RAM_1D => X"0000000001111000000000000001100000000000011110000000000000000000",
            INIT_RAM_1E => X"0000000000000000000000001000100000000000011110000000000010001000",
            INIT_RAM_1F => X"0000000011111110000000000001000000000000001010100000000000000000",
            INIT_RAM_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_RAM_28 => X"0000008888888BBB00000088888888880000008888888BBB0000008888888888",
            INIT_RAM_29 => X"000000888BBBBBBB000000888BBBB888000000888BBBBBBB000000888BBBB888",
            INIT_RAM_2A => X"0000008888888BBB00000088888888880000008888888BBB0000008888888888",
            INIT_RAM_2B => X"000000888BBBBBBB000000888BBBB888000000888BBBBBBB000000888BBBB888",
            INIT_RAM_2C => X"000000BBB8888BBB000000BBB8888888000000BBB8888BBB000000BBB8888888",
            INIT_RAM_2D => X"000000BBBBBBBBBB000000BBBBBBB888000000BBBBBBBBBB000000BBBBBBB888",
            INIT_RAM_2E => X"000000BBB8888BBB000000BBB8888888000000BBB8888BBB000000BBB8888888",
            INIT_RAM_2F => X"000000BBBBBBBBBB000000BBBBBBB888000000BBBBBBBBBB000000BBBBBBB888",
            INIT_RAM_30 => X"0000000001111100000000001111111000000000111110000000000001111100",
            INIT_RAM_31 => X"0000000001111100000000001111111000000000111111100000000011111110",
            INIT_RAM_32 => X"0000000011111110000000000100000000000000000000000000000011111110",
            INIT_RAM_33 => X"0000000001111100000000001111111000000000111111100000000011111110",
            INIT_RAM_34 => X"0000000001001100000000001111111000000000011111000000000011111110",
            INIT_RAM_35 => X"0000000001111110000000000000111000000000011111100000000000000010",
            INIT_RAM_36 => X"0000000000010000000000001100001000000000000001100000000011000110",
            INIT_RAM_37 => X"0000000000101000000000000001000000000000000100000000000000111110",
            INIT_RAM_38 => X"0000008888888BBB00000088888888880000008888888BBB0000008888888888",
            INIT_RAM_39 => X"000000888BBBBBBB000000888BBBB888000000888BBBBBBB000000888BBBB888",
            INIT_RAM_3A => X"0000008888888BBB00000088888888880000008888888BBB0000008888888888",
            INIT_RAM_3B => X"000000888BBBBBBB000000888BBBB888000000888BBBBBBB000000888BBBB888",
            INIT_RAM_3C => X"000000BBB8888BBB000000BBB8888888000000BBB8888BBB000000BBB8888888",
            INIT_RAM_3D => X"000000BBBBBBBBBB000000BBBBBBB888000000BBBBBBBBBB000000BBBBBBB888",
            INIT_RAM_3E => X"000000BBB8888BBB000000BBB8888888000000BBB8888BBB000000BBB8888888",
            INIT_RAM_3F => X"000000BBBBBBBBBB000000BBBBBBB888000000BBBBBBBBBB000000BBBBBBB888"
            )
        port map (
            DOA => doa_upper,
            DOB => dob_upper,
            CLKA => clock,
            OCEA => '1',
            CEA => '1',
            RESETA => '0',
            WREA => '0',
            CLKB => clock,
            OCEB => '1',
            CEB => '1',
            RESETB => '0',
            WREB => '0',
            BLKSELA => "000",
            BLKSELB => "000",
            ADA => addressA & "00",
            DIA => (others => '0'),
            ADB => addressB & "00",
            DIB =>  (others => '0')
            );

    QA <= doa_upper(3 downto 0) & doa_lower(3 downto 0);
    QB <= dob_upper(3 downto 0) & dob_lower(3 downto 0);

end RTL;
