-- Company: 			Dossytronics
-- Engineer: 			Dominic Beesley
-- 
-- Create Date:    	9/9/2023
-- Design Name: 
-- Module Name:    	hsync_meta
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 		Synchronise pixels to DVI clock domain
-- Dependencies: 
--
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;

entity hsync_meta is
	generic (
		G_LINE_PIXELS   : natural := 1728;  -- number of pixels per line in 27Mhz domain
		G_HSYNC_LEN  	 : natural := 128;
		G_RESYNC_MARGIN : natural := 5
		);
	port (
		reset_i			: in	std_logic;		-- reset;

		clock_dvi_i		: in	std_logic;		-- 27MHz pixel clock

		hsync_i			: in	std_logic;		-- hsync in from 48MHz/2MHz domain

		hsync_o			: out	std_logic		-- reconditioned hsync in 27MHz domain
	);
end hsync_meta;

architecture rtl of hsync_meta is

	function ceil_log2(i : natural) return natural is
	begin
   		return integer(ceil(log2(real(i))));  -- Example using real calculation
 	end function;

	-- number of bits required to hold a number
 	function numbits(w : natural) return natural is
	begin
		assert w > 0 report "width must be > 0" severity error;
		if w = 1 then
			return 1;
		else
			return ceil_log2(w);
		end if;
	end function;

	signal r_linecount		: unsigned(numbits(G_LINE_PIXELS-1)-1 downto 0);
	signal r_hsync_out		: std_logic;

	signal r_hsync_meta		: std_logic_vector(2 downto 0);

	signal r_short				: std_logic;	 -- 1 when scanning at 31KHz
	signal r_had_short		: std_logic;    -- set to 1 when a sync occurs near middle
begin

	hsync_o <= r_hsync_out;

	-- resample hsync_i for meta stability
	process(reset_i, clock_dvi_i)
	begin
		if reset_i = '1' then
			r_hsync_meta <= (others => '0');
		elsif rising_edge(clock_dvi_i) then
			r_hsync_meta <= hsync_i & r_hsync_meta(r_hsync_meta'high downto 1);
		end if;
	end process;

	-- capture 
	process(reset_i, clock_dvi_i)
	variable v_resync: boolean;
	variable v_longok: boolean;
	variable v_shortok: boolean;
	begin
		if reset_i = '1' then
			r_hsync_out <= '0';
			r_linecount <= (others => '0');
			r_short <= '0';
		elsif rising_edge(clock_dvi_i) then
			--look for "out of sync" condition
			v_resync := false;
			if r_hsync_meta(1 downto 0) = "10" then

				v_longok := r_linecount < G_RESYNC_MARGIN or r_linecount >= G_LINE_PIXELS - G_RESYNC_MARGIN;
				v_shortok:= r_linecount >= (G_LINE_PIXELS - G_RESYNC_MARGIN) / 2 and r_linecount < (G_LINE_PIXELS + G_RESYNC_MARGIN) / 2;

				if r_short = '0' then
					if not v_longok then
						v_resync := true;
						if v_shortok then
							r_short <= '1';
						end if;
					end if;
				else
					if v_shortok then
						r_had_short <= '1';
					elsif v_longok then						
						if r_had_short = '0' then
							-- missed one 
							v_resync := true;
							r_short <= '0';
						end if;
						r_had_short <= '0';
					else
						v_resync := true;
					end if;
				end if;
			end if;

			if r_linecount = 0 or v_resync then
				r_linecount <= to_unsigned(G_LINE_PIXELS-1, r_linecount'length);
			else
				r_linecount <= r_linecount - 1;
			end if;
		
			r_hsync_out <= '0';
			if r_short = '0' then
				if r_linecount < G_HSYNC_LEN then
					r_hsync_out <= '1';
				end if;
			else
				if r_linecount < G_HSYNC_LEN / 2 then
					r_hsync_out <= '1';
				end if;				
				if r_linecount >= G_LINE_PIXELS / 2 and r_linecount < (G_LINE_PIXELS + G_HSYNC_LEN) / 2 then
					r_hsync_out <= '1';
				end if;				
			end if;

		end if;

	end process;
		

end rtl;
	