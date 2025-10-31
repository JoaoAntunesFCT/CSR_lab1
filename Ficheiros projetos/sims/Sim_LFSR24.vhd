library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_LFSR24 is
end entity;

architecture sim of tb_LFSR24 is
  -- DUT signals
  signal Clk     : std_logic := '0';
  signal Reset   : std_logic := '0';
  signal Enable  : std_logic := '1';
  signal evt_in  : std_logic := '0';
  signal evt_out : std_logic;

  -- simulation control
  constant CLK_PERIOD : time := 10 ns;  -- 100 MHz
begin

  -------------------------------------------------
  -- Clock generation
  -------------------------------------------------
  clk_process : process
  begin
    Clk <= '0';
    wait for CLK_PERIOD / 2;
    Clk <= '1';
    wait for CLK_PERIOD / 2;
  end process;

  -------------------------------------------------
  -- Instantiate DUT (Device Under Test)
  -------------------------------------------------
  DUT : entity work.LFSR24
    port map (
      Clk     => Clk,
      Reset   => Reset,
      Enable  => Enable,
      evt_in  => evt_in,
      evt_out => evt_out
    );

  -------------------------------------------------
  -- Stimulus process
  -------------------------------------------------
  stim_proc : process
  begin
    -- Reset
    Reset <= '1';
    wait for 50 ns;
    Reset <= '0';

    -- Generate a few event pulses to trigger random delays
    wait for 100 ns;
    evt_in <= '1'; wait for CLK_PERIOD;
    evt_in <= '0'; wait for 3 ms;

    evt_in <= '1'; wait for CLK_PERIOD;
    evt_in <= '0'; wait for 3 ms;

    evt_in <= '1'; wait for CLK_PERIOD;
    evt_in <= '0'; wait for 5 ms;

    wait;  -- end simulation
  end process;
end architecture;
