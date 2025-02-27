-- MIT License
-- -----------------------------------------------------------------------------
-- Copyright (c) 2025 Dominic Beesley https://github.com/dominicbeesley
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
-- -----------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Company: 			Dossytronics
-- Engineer: 			Dominic Beesley
-- 
-- Create Date:    	27/2/2025
-- Design Name: 
-- Module Name:    	dac1_oser
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 		1 bit DAC using an OSER10 and fixed patterns
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dac1_oser is
	Generic (
		G_SAMPLE_SIZE		: natural := 10;
		G_SYNC_DEPTH		: natural := 1
	);
   Port (
		rst_i					: in  	std_logic;
		clk_dac_i			: in		std_logic;
		clk_dac_px_i		: in		std_logic;

		sample_i				: in		unsigned(G_SAMPLE_SIZE-1 downto 0);				-- sample in, will be registered in dac domain
		
		bitstream_o			: out		std_logic
	);
end dac1_oser;

architecture rtl of dac1_oser is

	COMPONENT OSER10
		GENERIC (GSREN:string:="false";
			LSREN:string:="true"
 		);
		PORT(
			Q:OUT std_logic;
			D0:IN std_logic;
			D1:IN std_logic;
			D2:IN std_logic;
			D3:IN std_logic;
			D4:IN std_logic;
			D5:IN std_logic;
			D6:IN std_logic;
			D7:IN std_logic;
			D8:IN std_logic;
			D9:IN std_logic;
			FCLK:IN std_logic;
			PCLK:IN std_logic;
			RESET:IN std_logic
 		);
	END COMPONENT;

	type	sample_arr	is array(natural range <>) of unsigned(G_SAMPLE_SIZE-1 downto 0);

	signal r_arr_clk_dac : sample_arr(G_SYNC_DEPTH downto 0);

	signal r_pat	: std_logic_vector(9 downto 0);

	function PAT(i:unsigned) return std_logic_vector is
	variable R : std_logic_vector(9 downto 0);
	begin

		case to_integer(i) is		
when 0 => R := "0000000000";
when 1 => R := "0000000000";
when 2 => R := "0000000000";
when 3 => R := "0000000000";
when 4 => R := "0000000100";
when 5 => R := "0000001000";
when 6 => R := "0000010000";
when 7 => R := "1000100010";
when 8 => R := "0001000100";
when 9 => R := "1001001000";
when 10 => R := "0001001001";
when 11 => R := "0010010010";
when 12 => R := "1010010100";
when 13 => R := "0010100101";
when 14 => R := "0010101010";
when 15 => R := "1010101010";
when 16 => R := "0101010101";
when 17 => R := "1101010101";
when 18 => R := "1101011010";
when 19 => R := "0101101011";
when 20 => R := "1101101101";
when 21 => R := "0110110110";
when 22 => R := "0110110111";
when 23 => R := "1110111011";
when 24 => R := "1111011101";
when 25 => R := "0111101111";
when 26 => R := "0111110111";
when 27 => R := "1111111011";
when 28 => R := "0111111111";
when 29 => R := "0111111111";
when 30 => R := "1111111111";
when others => R := "0111111111";
		end case;

		return R;

	end function;

begin


	r_arr_clk_dac(G_SYNC_DEPTH) <= sample_i;

	g_sync:if G_SYNC_DEPTH > 0 generate
		-- register the incoming sample to avoid metastability
		p_sync_sample:process(clk_dac_px_i)
		begin
			if rising_edge(clk_dac_px_i) then
				for I in 1 to G_SYNC_DEPTH loop
					r_arr_clk_dac(I-1) <= r_arr_clk_dac(I);
				end loop;
			end if;
		end process;
	end generate;

	g_reg_pat: process(clk_dac_px_i)
	begin
		if rising_edge(clk_dac_px_i) then
			r_pat <= PAT(r_arr_clk_dac(0));
		end if;
	end process;

	e_ser10:OSER10
		GENERIC MAP (
			GSREN=>"false",
			LSREN=>"true"
		)
		PORT MAP (
 			Q		=> bitstream_o,
 			D0		=> r_pat(0),
 			D1		=> r_pat(1),
 			D2		=> r_pat(2),
 			D3		=> r_pat(3),
 			D4		=> r_pat(4),
 			D5		=> r_pat(5),
 			D6		=> r_pat(6),
 			D7		=> r_pat(7),
 			D8		=> r_pat(8),
 			D9		=> r_pat(9),
 			FCLK	=> clk_dac_i,
 			PCLK	=> clk_dac_px_i,
 			RESET	=> '0'
 		);

end rtl;

