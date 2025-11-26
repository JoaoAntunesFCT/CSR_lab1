library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- Required for basic arithmetic operations

entity Segment_Display is
    port(
        Clk     : in  std_logic;
        Reset   : in  std_logic;
        Data_In : in  std_logic_vector(3 downto 0); -- 4 bits of data (0-9, A-F)
        
        -- Segment Cathodes (Commonly active-low for common-anode displays)
        CA : out std_logic;
        CB : out std_logic;
        CC : out std_logic;
        CD : out std_logic;
        CE : out std_logic;
        CF : out std_logic;
        CG : out std_logic;
        DP : out std_logic; -- Decimal Point

        -- Anode Selectors (Active-low, drives which segment is lit)
        AN : out std_logic_vector(7 downto 0) 
    );
end entity Segment_Display;

architecture Behavioral of Segment_Display is
    
    -- Internal signal to hold the currently decoded 7-segment pattern (active low)
    signal seg_data : std_logic_vector(7 downto 0); -- segments + DP

    -- We are driving a constant Data_In value, so we only need to decode it once.
    -- However, we must continuously multiplex the anodes.
    
    -- A simple clock divider for multiplexing (e.g., 1 KHz rate)
    constant CLK_DIV_BITS : integer := 16;
    signal clk_div_cnt : std_logic_vector(CLK_DIV_BITS-1 downto 0) := (others => '0');
    
    -- Anode control counter (3 bits needed to cycle through 8 displays)
    signal anode_cnt : std_logic_vector(2 downto 0) := (others => '0');

begin

    -- 1. Decode Data_In to 7-Segment Cathodes (Active Low)
    -- This process converts the 4-bit Data_In into the 7-segment pattern.
    with Data_In select
        seg_data <= 
            "10000000" when "0000", -- 0
            "11110010" when "0001", -- 1
            "10010001" when "0010", -- 2
            "10110000" when "0011", -- 3
            "11100010" when "0100", -- 4
            "10100100" when "0101", -- 5
            "10000100" when "0110", -- 6
            "11111000" when "0111", -- 7
            "10000000" when "1000", -- 8
            "10100000" when "1001", -- 9
            "10001000" when "1010", -- A (The arbitrary "1010" input value)
            "10000011" when "1011", -- B
            "10000110" when "1100", -- C
            "10010000" when "1101", -- D
            "10000110" when "1110", -- E
            "10001110" when "1111", -- F
            "11111111" when others; -- Blank default
            
    -- Assign decoded pattern to segment outputs (CA-CG) and DP
    CA <= seg_data(7); -- DP
    CB <= seg_data(6); -- CG
    CC <= seg_data(5); -- CF
    CD <= seg_data(4); -- CE
    CE <= seg_data(3); -- CD
    CF <= seg_data(2); -- CC
    CG <= seg_data(1); -- CB
    DP <= seg_data(0); -- CA
    
    
    -- 2. Multiplexing Control
    process(Clk)
    begin
        if rising_edge(Clk) then
            if Reset = '1' then
                clk_div_cnt <= (others => '0');
                anode_cnt <= (others => '0');
            else
                -- Divide clock down to a multiplexing rate (e.g., ~1KHz)
                if clk_div_cnt = (clk_div_cnt'range => '1') then -- Max count for 16 bits
                    clk_div_cnt <= (others => '0');
                    -- Cycle through anodes every time the slow clock ticks
                    anode_cnt <= anode_cnt + 1;
                else
                    clk_div_cnt <= clk_div_cnt + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- 3. Anode Output Drive
    -- Based on anode_cnt, activate only one anode (active low, '0')
    -- Since the displays are meant to show the same value, we just light up
    -- the single display corresponding to the lowest bit (AN[0]).
    AN <= (others => '1'); -- Deactivate all anodes by default (active high)
    
    -- Assign anode_cnt value to turn ON one specific display segment.
    -- Since the arbitrary number requires only one segment, we'll permanently enable AN(0).
    AN(0) <= '0';
    
end architecture Behavioral;