library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Define the entity with ALL external I/O pins from the XDC file.
entity top is
    port(
        -- FPGA System Inputs
        Clk      : in  std_logic;
        Reset    : in  std_logic; -- Reset Button (M17)
        Enable   : in  std_logic; -- Enable Switch (J15)

        -- Switch/Button Inputs mapped to internal signals and DUT inputs
        outi     : in  std_logic;
        ini      : in  std_logic;
        outi_2   : in  std_logic;
        ini_2    : in  std_logic;
        outi_3   : in  std_logic;
        ini_3    : in  std_logic;
        in1      : in  std_logic;

        -- LED/Arduino Outputs mapped to DUT outputs
        movei    : out std_logic;
        movei_2  : out std_logic;
        movei_3  : out std_logic;
        Bot1     : out std_logic;
        Bot2     : out std_logic;
        Bot3     : out std_logic
    );
end top;

architecture Behavioral of top is

    -- Component declaration for your main logic module
    component CSR_Lab_3_Part4_main
        port(
            Clk      : in  STD_LOGIC;
            outi     : in  STD_LOGIC;
            ini      : in  STD_LOGIC;
            outi_2   : in  STD_LOGIC;
            ini_2    : in  STD_LOGIC;
            outi_3   : in  STD_LOGIC;
            ini_3    : in  STD_LOGIC;
            in1      : in  STD_LOGIC;

            movei    : out STD_LOGIC;
            movei_2  : out STD_LOGIC;
            movei_3  : out STD_LOGIC;
            Bot1     : out STD_LOGIC;
            Bot2     : out STD_LOGIC;
            Bot3     : out STD_LOGIC;

            Enable   : in  STD_LOGIC;
            Reset    : in  STD_LOGIC
        );
    end component;

    -- Internal signals are no longer needed, as we connect the external ports
    -- directly to the component ports for simplicity.

begin

    -- Instantiate your component (Design Under Test)
    DUT: CSR_Lab_3_Part4_main
        port map(
            -- Connect main inputs from top entity
            Clk      => Clk,
            Reset    => Reset,
            Enable   => Enable,

            -- Connect switch/JD inputs to DUT inputs
            outi     => outi,
            ini      => ini,
            outi_2   => outi_2,
            ini_2    => ini_2,
            outi_3   => outi_3,
            ini_3    => ini_3,
            in1      => in1,

            -- Connect DUT outputs to top entity outputs (LEDs/JC pins)
            movei    => movei,
            movei_2  => movei_2,
            movei_3  => movei_3,
            Bot1     => Bot1,
            Bot2     => Bot2,
            Bot3     => Bot3
        );

end Behavioral;