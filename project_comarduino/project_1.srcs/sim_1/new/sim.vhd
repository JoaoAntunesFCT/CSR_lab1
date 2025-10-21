-- Testbench for CSR_Lab3_Part4
-- Filename: tb_CSR_Lab3_Part4.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_CSR_Lab3_Part4 is
end tb_CSR_Lab3_Part4;

architecture sim of tb_CSR_Lab3_Part4 is

  -- DUT signals
  signal Clk        : std_logic := '0';
  signal ini        : std_logic := '0';
  signal outi       : std_logic := '0';
  signal ini_2      : std_logic := '0';
  signal outi_2     : std_logic := '0';
  signal ini_3      : std_logic := '0';
  signal outi_3     : std_logic := '0';
  signal in1        : std_logic := '0';
  signal Bot1_i     : std_logic := '0';
  signal Bot2_i     : std_logic := '0';
  signal Bot3_i     : std_logic := '0';
  signal movei_i    : std_logic := '0';
  signal movei_2_i  : std_logic := '0';
  signal movei_3_i  : std_logic := '0';
  signal Bot1       : std_logic;
  signal Bot2       : std_logic;
  signal Bot3       : std_logic;
  signal movei      : std_logic;
  signal movei_2    : std_logic;
  signal movei_3    : std_logic;
  signal in1_o      : std_logic;
  signal ini_o      : std_logic;
  signal outi_o     : std_logic;
  signal ini_2_o    : std_logic;
  signal outi_2_o   : std_logic;
  signal ini_3_o    : std_logic;
  signal outi_3_o   : std_logic;
  signal Enable     : std_logic := '0';
  signal Reset      : std_logic := '0';

  constant CLK_PERIOD : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: entity work.CSR_Lab3_Part4
    port map (
      Clk       => Clk,
      ini       => ini,
      outi      => outi,
      ini_2     => ini_2,
      outi_2    => outi_2,
      ini_3     => ini_3,
      outi_3    => outi_3,
      in1       => in1,
      Bot1_i    => Bot1_i,
      Bot2_i    => Bot2_i,
      Bot3_i    => Bot3_i,
      movei_i   => movei_i,
      movei_2_i => movei_2_i,
      movei_3_i => movei_3_i,
      Bot1      => Bot1,
      Bot2      => Bot2,
      Bot3      => Bot3,
      movei     => movei,
      movei_2   => movei_2,
      movei_3   => movei_3,
      in1_o     => in1_o,
      ini_o     => ini_o,
      outi_o    => outi_o,
      ini_2_o   => ini_2_o,
      outi_2_o  => outi_2_o,
      ini_3_o   => ini_3_o,
      outi_3_o  => outi_3_o,
      Enable    => Enable,
      Reset     => Reset
    );

  -- Clock generation
  clk_proc : process
  begin
    while now < 5 ms loop
      Clk <= '0';
      wait for CLK_PERIOD / 2;
      Clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process clk_proc;

  -- Stimulus process: reset, enable, then pulse inputs to exercise transitions
  stim_proc : process
  begin
    -- initial reset (Reset is active '1' in your design)
    Reset <= '1';
    Enable <= '0';
    wait for 4 * CLK_PERIOD;

    -- release reset and enable
    Reset <= '0';
    Enable <= '1';
    wait for 2 * CLK_PERIOD;

    -- Sequence: pulse each input high for one clock then low (to trigger tr_3)
    -- and after a short delay pulse low-to-high patterns that exercise the reverse transition (tr_4).
    -- Bot1 : pulse
    Bot1_i <= '1';
    wait until rising_edge(Clk);
    Bot1_i <= '0';
    wait until rising_edge(Clk);

    -- Bot1 back to 0 already; pulse 0->1->0 again to show toggling
    Bot1_i <= '1';
    wait until rising_edge(Clk);
    Bot1_i <= '0';
    wait until rising_edge(Clk);

    -- Bot2
    Bot2_i <= '1';
    wait until rising_edge(Clk);
    Bot2_i <= '0';
    wait until rising_edge(Clk);

    -- Bot3
    Bot3_i <= '1';
    wait until rising_edge(Clk);
    Bot3_i <= '0';
    wait until rising_edge(Clk);

    -- movei
    movei_i <= '1';
    wait until rising_edge(Clk);
    movei_i <= '0';
    wait until rising_edge(Clk);

    -- movei_2
    movei_2_i <= '1';
    wait until rising_edge(Clk);
    movei_2_i <= '0';
    wait until rising_edge(Clk);

    -- movei_3
    movei_3_i <= '1';
    wait until rising_edge(Clk);
    movei_3_i <= '0';
    wait until rising_edge(Clk);

    -- in1
    in1 <= '1';
    wait until rising_edge(Clk);
    in1 <= '0';
    wait until rising_edge(Clk);

    -- ini
    ini <= '1';
    wait until rising_edge(Clk);
    ini <= '0';
    wait until rising_edge(Clk);

    -- outi
    outi <= '1';
    wait until rising_edge(Clk);
    outi <= '0';
    wait until rising_edge(Clk);

    -- ini_2
    ini_2 <= '1';
    wait until rising_edge(Clk);
    ini_2 <= '0';
    wait until rising_edge(Clk);

    -- outi_2
    outi_2 <= '1';
    wait until rising_edge(Clk);
    outi_2 <= '0';
    wait until rising_edge(Clk);

    -- ini_3
    ini_3 <= '1';
    wait until rising_edge(Clk);
    ini_3 <= '0';
    wait until rising_edge(Clk);

    -- outi_3
    outi_3 <= '1';
    wait until rising_edge(Clk);
    outi_3 <= '0';
    wait until rising_edge(Clk);

    -- Now run a mixed activity phase: toggle several inputs at once for a few clocks
    Bot1_i <= '1';
    Bot2_i <= '1';
    movei_i <= '1';
    wait until rising_edge(Clk);
    Bot1_i <= '0';
    Bot2_i <= '0';
    movei_i <= '0';
    wait until rising_edge(Clk);

    -- let the system settle for a few clocks while monitoring outputs
    wait for 10 * CLK_PERIOD;

    -- End simulation
    report "End of testbench stimulus - stopping simulation." severity note;
    wait;
  end process stim_proc;

  -- Monitoring process: print outputs at each rising_edge
  monitor_proc : process
  begin
    wait until rising_edge(Clk);
    -- Print a compact status line each clock
    report "T=" & integer'image(integer(now / 1 ns)) & "ns | Reset=" & std_logic'image(Reset)
           & " Enable=" & std_logic'image(Enable)
           & " | Inputs: Bot1_i=" & std_logic'image(Bot1_i)
           & " Bot2_i=" & std_logic'image(Bot2_i)
           & " Bot3_i=" & std_logic'image(Bot3_i)
           & " movei_i=" & std_logic'image(movei_i)
           & " movei_2_i=" & std_logic'image(movei_2_i)
           & " movei_3_i=" & std_logic'image(movei_3_i)
           & " in1=" & std_logic'image(in1)
           & " ini=" & std_logic'image(ini)
           & " outi=" & std_logic'image(outi)
           & " ini_2=" & std_logic'image(ini_2)
           & " outi_2=" & std_logic'image(outi_2)
           & " ini_3=" & std_logic'image(ini_3)
           & " outi_3=" & std_logic'image(outi_3)
           & " | Outputs: Bot1=" & std_logic'image(Bot1)
           & " Bot2=" & std_logic'image(Bot2)
           & " Bot3=" & std_logic'image(Bot3)
           & " movei=" & std_logic'image(movei)
           & " movei_2=" & std_logic'image(movei_2)
           & " movei_3=" & std_logic'image(movei_3)
           & " in1_o=" & std_logic'image(in1_o)
           & " ini_o=" & std_logic'image(ini_o)
           & " outi_o=" & std_logic'image(outi_o)
           & " ini_2_o=" & std_logic'image(ini_2_o)
           & " outi_2_o=" & std_logic'image(outi_2_o)
           & " ini_3_o=" & std_logic'image(ini_3_o)
           & " outi_3_o=" & std_logic'image(outi_3_o);
    -- loop continues automatically, since process has no termination
  end process monitor_proc;

end architecture sim;
