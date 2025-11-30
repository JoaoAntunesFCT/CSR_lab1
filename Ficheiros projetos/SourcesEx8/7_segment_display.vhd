
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Segment_Display is
    port(
        Clk     : in  std_logic;
        Reset   : in  std_logic;

        marks_43    : in integer range 0 to 3;
        marks_89_43 : in integer range 0 to 3;
        marks_90_43 : in integer range 0 to 3;

        CA : out std_logic;
        CB : out std_logic;
        CC : out std_logic;
        CD : out std_logic;
        CE : out std_logic;
        CF : out std_logic;
        CG : out std_logic;
        DP : out std_logic;
        AN : out std_logic_vector(7 downto 0)
    );
end entity Segment_Display;


architecture Behavioral of Segment_Display is

    signal seg_data   : std_logic_vector(6 downto 0);
    signal digit_val  : std_logic_vector(3 downto 0);

    signal Display_Value : std_logic_vector(11 downto 0);

    constant CLK_DIV_BITS : integer := 16;
    signal clk_div_cnt : std_logic_vector(CLK_DIV_BITS-1 downto 0) := (others => '0');
    signal anode_cnt   : std_logic_vector(1 downto 0) := (others => '0'); -- 3 digits

begin

    -- Compute complementary values for the display
    Display_Value(3 downto 0)   <= std_logic_vector(to_unsigned(3 - marks_43, 4));
    Display_Value(7 downto 4)   <= std_logic_vector(to_unsigned(3 - marks_89_43, 4));
    Display_Value(11 downto 8)  <= std_logic_vector(to_unsigned(3 - marks_90_43, 4));

    ----------------------------------------------------------------
    -- Clock divider for multiplexing
    ----------------------------------------------------------------
    process(Clk, Reset)
    begin
        if Reset = '1' then
            clk_div_cnt <= (others => '0');
            anode_cnt <= (others => '0');
        elsif rising_edge(Clk) then
            if clk_div_cnt = (clk_div_cnt'range => '1') then
                clk_div_cnt <= (others => '0');
                anode_cnt <= anode_cnt + 1;
            else
                clk_div_cnt <= clk_div_cnt + 1;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Select digit to display based on anode count
    ----------------------------------------------------------------
    with anode_cnt select
        digit_val <= Display_Value(3 downto 0)   when "00",
                     Display_Value(7 downto 4)   when "01",
                     Display_Value(11 downto 8)  when "10",
                     "0000"                      when others;

    ----------------------------------------------------------------
    -- 7-segment decoder (active low)
    ----------------------------------------------------------------
    with digit_val select
        seg_data <=
            "0000001" when "0000", -- 0
            "1001111" when "0001", -- 1
            "0010010" when "0010", -- 2
            "0000110" when "0011", -- 3
            "1001100" when "0100", -- 4
            "0100100" when "0101", -- 5
            "0100000" when "0110", -- 6
            "0001111" when "0111", -- 7
            "0000000" when "1000", -- 8
            "0000100" when "1001", -- 9
            "1111111" when others; -- blank

    ----------------------------------------------------------------
    -- Map segments
    ----------------------------------------------------------------
    CA <= seg_data(6);
    CB <= seg_data(5);
    CC <= seg_data(4);
    CD <= seg_data(3);
    CE <= seg_data(2);
    CF <= seg_data(1);
    CG <= seg_data(0);
    DP <= '1'; -- decimal point off

    ----------------------------------------------------------------
    -- Multiplexed anode output (active low)
    ----------------------------------------------------------------
    AN <= "11111111"; -- default all off
    AN(0) <= '0' when anode_cnt = "00" else '1';
    AN(1) <= '0' when anode_cnt = "01" else '1';
    AN(2) <= '0' when anode_cnt = "10" else '1';

end architecture Behavioral;
