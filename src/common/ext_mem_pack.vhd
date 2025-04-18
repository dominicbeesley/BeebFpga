-- Copyright (c) 2015-2025 David Banks
-- Copyright (c) 2025 Dominic Beesley
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- * Redistributions in synthesized form must reproduce the above copyright
--   notice, this list of conditions and the following disclaimer in the
--   documentation and/or other materials provided with the distribution.
--
-- * Neither the name of the author nor the names of other contributors may
--   be used to endorse or promote products derived from this software without
--   specific prior written agreement from the author.
--
-- * License is granted for non-commercial use only.  A fee may not be charged
--   for redistributions as source code or in synthesized/hardware form without
--   specific prior written agreement from the author.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- External memory interface package, defines device-agnostic protocol for 
-- accessing memory from core


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package ext_mem_pack is

    constant EXT_MEM_A_WIDTH : natural := 19;

    type em_c2m_t is record
        A_stb      : std_logic;
        nOE        : std_logic;
        nWE        : std_logic;
        nWE_long   : std_logic;                                       -- TODO: consider making this device specific, they won't all want a quick strobe at same phase?
        nCS        : std_logic;
        A          : std_logic_vector (EXT_MEM_A_WIDTH-1 downto 0);
        D          : std_logic_vector (7 downto 0);
    end record em_c2m_t;


    type em_m2c_t is record
        D          : std_logic_vector (7 downto 0);
        busy       : std_logic;                                       -- Use by bootstrapper to wait for slow initialisation of sdram controller, ignored in core
    end record em_m2c_t;

end ext_mem_pack;