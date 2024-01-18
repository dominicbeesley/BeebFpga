------------------------------------------------------------------------
-- quadrature_fsm.vhd
------------------------------------------------------------------------
-- Author : David Banks
--              Copyright 2016

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity quadrature_fsm is
generic (
        DIV_FACTOR : natural := 1; -- number of bits of dpi to ignore
        ACC_SIZE   : natural := 10;
        ACC_MAX    : positive := 200
    );
port (
    clk  : in std_logic;
    rst  : in std_logic;
    load : in std_logic;
    inc  : in std_logic_vector(7 downto 0);
    sign : in std_logic;
    ao   : out std_logic;
    bo   : out std_logic
);
end quadrature_fsm;

architecture Behavioral of quadrature_fsm is

  signal r_accumulator  : signed(ACC_SIZE-1 downto 0);
  signal i_sinc         : signed(8 downto 0);
  signal r_delay        : unsigned(15-DIV_FACTOR downto 0);

  signal r_phase        : unsigned(DIV_FACTOR+1 downto 0);

  -- signal from phase to acc processes
  signal r_incdec_req   : std_logic;
  signal r_incdec_ack   : std_logic;

begin

  i_sinc <= signed(sign & inc);

  p_acc:process(rst,clk)
  begin
    if rst = '1' then
      r_accumulator <= to_signed(0, r_accumulator'length);
      r_incdec_ack <= '0';
    elsif rising_edge(clk) then
      if load = '1' then
        if (sign = '1' and to_integer(r_accumulator) > -ACC_MAX) or
           (sign = '0' and to_integer(r_accumulator) < ACC_MAX) then
           r_accumulator <= r_accumulator + i_sinc;
        end if;
      elsif r_incdec_req /= r_incdec_ack then
        
        if r_accumulator > 0 then
          r_accumulator <= r_accumulator - 1;
        elsif r_accumulator < 0 then
          r_accumulator <= r_accumulator + 1;
        end if;

        r_incdec_ack <= r_incdec_req;
      end if;
    end if;

  end process;
  
  p_phase:process(rst, clk)
  begin
    if rst = '1' then
      r_delay <= (others => '0');
      r_incdec_req <= '0';
      r_phase <= (others => '0');
      ao <= '0';
      bo <= '0';
    elsif rising_edge(clk) then
      if r_delay = 0 then
        if r_accumulator > 0 then
          r_phase <= r_phase + 1;
        elsif r_accumulator < 0 then
          r_phase <= r_phase - 1;
        end if;

        case std_logic_vector(r_phase(r_phase'high downto r_phase'high -1)) is
          when "01" =>
            ao <= '1';
            bo <= '0';
          when "10" =>
            ao <= '1';
            bo <= '1';
          when "11" =>
            ao <= '0';
            bo <= '1';
          when others =>
            ao <= '0';
            bo <= '0';
        end case;

        r_incdec_req <= not r_incdec_req;
          
      end if;

      r_delay <= r_delay - 1;
    end if;
  end process;


end;
