-- ============================================================
-- Testbench for CSR_Lab_3_Part1_main
-- Simulates the same TD input sequence as the earlier example,
-- now including the LFSR-based event delay system.
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_CSR_Lab_3_Part1_main is
end entity;

architecture sim of tb_CSR_Lab_3_Part1_main is

    -- DUT signals
    signal Clk     : std_logic := '0';
    signal Enable  : std_logic := '1';
    signal Reset   : std_logic := '0';

    signal ini, outi         : std_logic := '0';
    signal ini_2, outi_2     : std_logic := '0';
    signal ini_3, outi_3     : std_logic := '0';
    signal in1               : std_logic := '0';

    signal movei, movei_2, movei_3 : std_logic;
    signal Bot1, Bot2, Bot3        : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        Clk <= '0';
        wait for CLK_PERIOD / 2;
        Clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    --------------------------------------------------------------------
    -- Instantiate DUT
    --------------------------------------------------------------------
    DUT : entity work.CSR_Lab_3_Part1_main
        port map (
            Clk      => Clk,
            Enable   => Enable,
            Reset    => Reset,
            ini      => ini,
            outi     => outi,
            ini_2    => ini_2,
            outi_2   => outi_2,
            ini_3    => ini_3,
            outi_3   => outi_3,
            in1      => in1,
            movei    => movei,
            movei_2  => movei_2,
            movei_3  => movei_3,
            Bot1     => Bot1,
            Bot2     => Bot2,
            Bot3     => Bot3
        );

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    stim_proc : process
    begin
        ----------------------------------------------------------------
        -- Reset system
        ----------------------------------------------------------------
        Reset <= '1';
        wait for 50 ns;
        Reset <= '0';
        wait for 50 ns;

        in1 <= '1';
        wait for 100 ns;
        in1 <= '0';
        wait for 50 ns;

        ----------------------------------------------------------------
        -- TD1 cycle (same pattern as your earlier example)
        ----------------------------------------------------------------
        ini  <= '0'; outi <= '1'; wait for 200 ns;
        ini  <= '1'; outi <= '0'; wait for 200 ns;
        ini  <= '0'; outi <= '0'; wait for 200 ns;

        ----------------------------------------------------------------
        -- TD2 cycle (same timing)
        ----------------------------------------------------------------
        ini_2  <= '0'; outi_2 <= '1'; wait for 200 ns;
        ini_2  <= '1'; outi_2 <= '0'; wait for 200 ns;
        ini_2  <= '0'; outi_2 <= '0'; wait for 200 ns;

        ----------------------------------------------------------------
        -- TD3 cycle (same timing)
        ----------------------------------------------------------------
        ini_3  <= '0'; outi_3 <= '1'; wait for 200 ns;
        ini_3  <= '1'; outi_3 <= '0'; wait for 200 ns;
        ini_3  <= '0'; outi_3 <= '0'; wait for 200 ns;

        ----------------------------------------------------------------
        -- End of simulation
        ----------------------------------------------------------------
        report " Simulation completed successfully." severity note;
        wait;
    end process;

end architecture;
