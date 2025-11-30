library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CSR_Lab_3_Part8_main is
    Port(
        Clk     : in  STD_LOGIC;
        Enable  : in  STD_LOGIC;
        Reset   : in  STD_LOGIC;

        -- Sensor Inputs
        ini     : in STD_LOGIC;
        outi    : in STD_LOGIC;

        ini_2   : in STD_LOGIC;
        outi_2  : in STD_LOGIC;

        ini_3   : in STD_LOGIC;
        outi_3  : in STD_LOGIC;

        in1     : in STD_LOGIC;

        -- Controller Outputs
        movei   : out STD_LOGIC;
        movei_2 : out STD_LOGIC;
        movei_3 : out STD_LOGIC;

        Bot1    : out STD_LOGIC;
        Bot2    : out STD_LOGIC;
        Bot3    : out STD_LOGIC;

        -- 7-seg Display
        CA : OUT STD_LOGIC;
        CB : OUT STD_LOGIC;
        CC : OUT STD_LOGIC;
        CD : OUT STD_LOGIC;
        CE : OUT STD_LOGIC;
        CF : OUT STD_LOGIC;
        CG : OUT STD_LOGIC;
        DP : OUT STD_LOGIC;
        AN : OUT STD_LOGIC_VECTOR(7 downto 0)
    );
end CSR_Lab_3_Part8_main;

architecture Structural of CSR_Lab_3_Part8_main is

    --------------------------------------------------------------------
    -- Controller Component
    --------------------------------------------------------------------
    component CSR_Lab_3_Part8 is
        Port(
            Clk   : in  STD_LOGIC;

            out1  : in  STD_LOGIC;
            in1   : in  STD_LOGIC;
            in2   : in  STD_LOGIC;
            in3   : in  STD_LOGIC;
            out2  : in  STD_LOGIC;
            out3  : in  STD_LOGIC;
            in4   : in  STD_LOGIC;

            movei   : out STD_LOGIC;
            Bot1    : out STD_LOGIC;
            movei_2 : out STD_LOGIC;
            Bot2    : out STD_LOGIC;
            movei_3 : out STD_LOGIC;
            Bot3    : out STD_LOGIC;

            Enable  : in STD_LOGIC;
            Reset   : in STD_LOGIC;

            marks_43    : out INTEGER range 0 to 3;
            marks_89_43 : out INTEGER range 0 to 3;
            marks_90_43 : out INTEGER range 0 to 3
        );
    end component;

    --------------------------------------------------------------------
    -- Segment Display Component
    --------------------------------------------------------------------
    component Segment_Display is
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
    end component;

    --------------------------------------------------------------------
    -- Internal Signals
    --------------------------------------------------------------------
    signal m43     : INTEGER range 0 to 3;
    signal m89_43  : INTEGER range 0 to 3;
    signal m90_43  : INTEGER range 0 to 3;

begin

    --------------------------------------------------------------------
    -- Instantiate Controller
    --------------------------------------------------------------------
    U_CTRL : CSR_Lab_3_Part8
    port map(
        Clk  => Clk,

        out1 => outi,
        in1  => in1,
        in2  => ini,
        in3  => ini_2,
        out2 => outi_2,
        out3 => outi_3,
        in4  => ini_3,

        movei   => movei,
        Bot1    => Bot1,
        movei_2 => movei_2,
        Bot2    => Bot2,
        movei_3 => movei_3,
        Bot3    => Bot3,

        Enable => Enable,
        Reset  => Reset,

        marks_43    => m43,
        marks_89_43 => m89_43,
        marks_90_43 => m90_43
    );

    --------------------------------------------------------------------
    -- Instantiate 7-Segment Display
    --------------------------------------------------------------------
    U_7SEG : Segment_Display
    port map(
        Clk => Clk,
        Reset => Reset,

        marks_43 => m43,
        marks_89_43 => m89_43,
        marks_90_43 => m90_43,

        CA => CA,
        CB => CB,
        CC => CC,
        CD => CD,
        CE => CE,
        CF => CF,
        CG => CG,
        DP => DP,
        AN => AN
    );

end Structural;
