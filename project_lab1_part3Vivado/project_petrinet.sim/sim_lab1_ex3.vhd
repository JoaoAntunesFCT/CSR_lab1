library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Need these libraries for the unit under test (UUT)
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sim_lab1_ex3 is
end sim_lab1_ex3;

architecture Behavioral of sim_lab1_ex3 is

    -- Component Declaration for the Unit Under Test (UUT)
    component CSR_Lab3_Part4
    Port(
        Clk : IN STD_LOGIC;
        ini : IN STD_LOGIC;
        outi : IN STD_LOGIC;
        ini_2 : IN STD_LOGIC;
        outi_2 : IN STD_LOGIC;
        ini_3 : IN STD_LOGIC;
        outi_3 : IN STD_LOGIC;
        in1 : IN STD_LOGIC;
        Bot1_i : IN STD_LOGIC;
        Bot2_i : IN STD_LOGIC;
        Bot3_i : IN STD_LOGIC;
        movei_i : IN STD_LOGIC;
        movei_2_i : IN STD_LOGIC;
        movei_3_i : IN STD_LOGIC;
        Bot1 : OUT STD_LOGIC;
        Bot2 : OUT STD_LOGIC;
        Bot3 : OUT STD_LOGIC;
        movei : OUT STD_LOGIC;
        movei_2 : OUT STD_LOGIC;
        movei_3 : OUT STD_LOGIC;
        in1_o : OUT STD_LOGIC;
        ini_o : OUT STD_LOGIC;
        outi_o : OUT STD_LOGIC;
        ini_2_o : OUT STD_LOGIC;
        outi_2_o : OUT STD_LOGIC;
        ini_3_o : OUT STD_LOGIC;
        outi_3_o : OUT STD_LOGIC;
        Enable : IN STD_LOGIC;
        Reset : IN STD_LOGIC
    );
    end component;

    -- Signal Declarations for UUT Ports
    signal Clk : STD_LOGIC := '0';
    signal ini, outi, ini_2, outi_2, ini_3, outi_3 : STD_LOGIC := '0';
    signal in1 : STD_LOGIC := '0';
    signal Bot1_i, Bot2_i, Bot3_i : STD_LOGIC := '0';
    signal movei_i, movei_2_i, movei_3_i : STD_LOGIC := '0';
    signal Enable : STD_LOGIC := '1'; -- Assuming Enable is active high
    signal Reset : STD_LOGIC := '1';  -- Active high reset for initial state

    signal Bot1, Bot2, Bot3 : STD_LOGIC;
    signal movei, movei_2, movei_3 : STD_LOGIC;
    signal in1_o, ini_o, outi_o : STD_LOGIC;
    signal ini_2_o, outi_2_o, ini_3_o, outi_3_o : STD_LOGIC;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: CSR_Lab3_Part4 Port Map (
        Clk => Clk,
        ini => ini,
        outi => outi,
        ini_2 => ini_2,
        outi_2 => outi_2,
        ini_3 => ini_3,
        outi_3 => outi_3,
        in1 => in1,
        Bot1_i => Bot1_i,
        Bot2_i => Bot2_i,
        Bot3_i => Bot3_i,
        movei_i => movei_i,
        movei_2_i => movei_2_i,
        movei_3_i => movei_3_i,
        Bot1 => Bot1,
        Bot2 => Bot2,
        Bot3 => Bot3,
        movei => movei,
        movei_2 => movei_2,
        movei_3 => movei_3,
        in1_o => in1_o,
        ini_o => ini_o,
        outi_o => outi_o,
        ini_2_o => ini_2_o,
        outi_2_o => outi_2_o,
        ini_3_o => ini_3_o,
        outi_3_o => outi_3_o,
        Enable => Enable,
        Reset => Reset
    );

    -- Clock generation process
    clk_process : process
    begin
        loop
            Clk <= '0';
            wait for CLK_PERIOD/2;
            Clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process clk_process;

    -- Stimulus process
    stim_process : process
    begin
        -- 1. Initial Reset (Assuming Reset is active high)
        Reset <= '1';
        wait for CLK_PERIOD * 2;
        Reset <= '0';
        wait for CLK_PERIOD * 2; -- Wait for initial state to settle after reset release

        -- The provided logic for transitions checks for input being '1' (conv_integer = 1) or '0' (conv_integer = 0).
        -- I will activate each signal for 2 clock cycles.

        -- 2. Activate in1
        report "--- Activating in1 ---" severity NOTE;
        in1 <= '1';
        wait for CLK_PERIOD * 2;
        in1 <= '0';
        wait for CLK_PERIOD * 2;

        -- 3. Activate outi
        report "--- Activating outi ---" severity NOTE;
        outi <= '1';
        wait for CLK_PERIOD * 2;
        outi <= '0';
        wait for CLK_PERIOD * 2;

        -- 4. Activate ini
        report "--- Activating ini ---" severity NOTE;
        ini <= '1';
        wait for CLK_PERIOD * 2;
        ini <= '0';
        wait for CLK_PERIOD * 2;

        -- 5. Activate outi_2
        report "--- Activating outi_2 ---" severity NOTE;
        outi_2 <= '1';
        wait for CLK_PERIOD * 2;
        outi_2 <= '0';
        wait for CLK_PERIOD * 2;

        -- 6. Activate ini_2
        report "--- Activating ini_2 ---" severity NOTE;
        ini_2 <= '1';
        wait for CLK_PERIOD * 2;
        ini_2 <= '0';
        wait for CLK_PERIOD * 2;

        -- 7. Activate outi_3
        report "--- Activating outi_3 ---" severity NOTE;
        outi_3 <= '1';
        wait for CLK_PERIOD * 2;
        outi_3 <= '0';
        wait for CLK_PERIOD * 2;

        -- 8. Activate ini_3
        report "--- Activating ini_3 ---" severity NOTE;
        ini_3 <= '1';
        wait for CLK_PERIOD * 2;
        ini_3 <= '0';
        wait for CLK_PERIOD * 2;

        -- Hold simulation
        report "--- Simulation Finished ---" severity NOTE;
        wait;
    end process stim_process;

end Behavioral;