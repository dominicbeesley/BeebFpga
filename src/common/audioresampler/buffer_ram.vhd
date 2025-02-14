library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buffer_ram is
    generic(
        A_WIDTH : integer;
        D_WIDTH : integer
        );
    port (
        clk     : in  std_logic;
        clk_en  : in  std_logic;
        we      : in  std_logic;
        wr_addr : in  unsigned(A_WIDTH - 1 downto 0);
        wr_data : in  signed(D_WIDTH - 1 downto 0);
        rd_addr : in  unsigned(A_WIDTH - 1 downto 0);
        rd_data : out signed(D_WIDTH - 1 downto 0)
        );
end;

architecture rtl of buffer_ram is

    type t_buffer_ram is array(0 to 2**A_WIDTH - 1) of signed(D_WIDTH - 1 downto 0);
    shared variable ram : t_buffer_ram := (others => (others => '0'));

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if clk_en = '1' then
                if we = '1' then
                    ram(to_integer(wr_addr)) := wr_data;
                end if;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if clk_en = '1' then
                rd_data <= ram(to_integer(rd_addr));
            end if;
        end if;
    end process;

end rtl;
