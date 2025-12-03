library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CSR_Lab_3_Part4_main is
    port(
        Clk      : in  STD_LOGIC;

        -- JD header inputs (switches/buttons)
        outi     : in  STD_LOGIC;
        ini      : in  STD_LOGIC;
        outi_2   : in  STD_LOGIC;
        ini_2    : in  STD_LOGIC;
        outi_3   : in  STD_LOGIC;
        ini_3    : in  STD_LOGIC;
        in1      : in  STD_LOGIC;

        -- JC header inputs (from Arduino, drives LEDs)
        JC1 : in std_logic;
        JC2 : in std_logic;
        JC3 : in std_logic;
        JC4 : in std_logic;
        JC5 : in std_logic;
        JC6 : in std_logic;

        -- JD header outputs (to Arduino, or just expose switches)
        JD1 : out std_logic;
        JD2 : out std_logic;
        JD3 : out std_logic;
        JD4 : out std_logic;
        JD5 : out std_logic;
        JD6 : out std_logic;
        JD7 : out std_logic;

        -- JC header outputs (LEDs on FPGA board)
        movei    : out STD_LOGIC;
        movei_2  : out STD_LOGIC;
        movei_3  : out STD_LOGIC;
        Bot1     : out STD_LOGIC;
        Bot2     : out STD_LOGIC;
        Bot3     : out STD_LOGIC;

        Enable   : in  STD_LOGIC;
        Reset    : in  STD_LOGIC
    );
end CSR_Lab_3_Part4_main;

architecture Behavioral of CSR_Lab_3_Part4_main is
begin

    -------------------------------------------------------------------
    -- Map JD switches/buttons to JD outputs
    -------------------------------------------------------------------
    JD1 <= in1;
    JD2 <= outi;
    JD3 <= ini;
    JD4 <= outi_2;
    JD5 <= ini_2;
    JD6 <= outi_3;
    JD7 <= ini_3;

    -------------------------------------------------------------------
    -- Map JC inputs (from Arduino) to LED outputs
    -------------------------------------------------------------------
    movei   <= JC1;
    movei_2 <= JC2;
    movei_3 <= JC3;
    Bot1    <= JC4;
    Bot2    <= JC5;
    Bot3    <= JC6;

end Behavioral;
