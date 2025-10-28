-- =============================================================
-- Testbench for 24-bit LFSR (LFSR24)
-- Polynomial: x^24 + x^23 + x^22 + x^17 + 1
-- Seed: 1
-- =============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity tb_LFSR24 is
end entity;

architecture sim of tb_LFSR24 is

    -- DUT signals
    signal Clk    : std_logic := '0';
    signal Reset  : std_logic := '0';
    signal Enable : std_logic := '1';
    signal Q      : std_logic_vector(23 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    ----------------------------------------------------------------
    -- Clock generation (100 MHz)
    ----------------------------------------------------------------
    clk_process : process
    begin
        Clk <= '0';
        wait for CLK_PERIOD / 2;
        Clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    ----------------------------------------------------------------
    -- Device Under Test
    ----------------------------------------------------------------
    DUT : entity work.LFSR24
        port map (
            Clk    => Clk,
            Reset  => Reset,
            Enable => Enable,
            Q      => Q
        );

    ----------------------------------------------------------------
    -- Stimulus
    ----------------------------------------------------------------
    stim_proc : process
        variable L : line;
    begin
        -- Apply synchronous reset
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';

        -- Run for some cycles
        for i in 0 to 50 loop
            wait until rising_edge(Clk);
            write(L, string'("Cycle "));
            write(L, i, right, 4);
            write(L, string'(": Q = "));
            write(L, Q);
            writeline(output, L);
        end loop;

        report "LFSR24 test completed successfully." severity note;
        wait;
    end process;

end architecture;
