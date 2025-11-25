-- =============================================================
-- CSR_Lab_3_Part1_main with LFSR-based Event Delay
-- =============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- compatible with your older files

entity CSR_Lab_3_Part1_main is
    port(
        Clk     : in  std_logic;
        Enable  : in  std_logic;
        Reset   : in  std_logic;
        ini     : in  std_logic;
        outi    : in  std_logic;
        ini_2   : in  std_logic;
        outi_2  : in  std_logic;
        ini_3   : in  std_logic;
        outi_3  : in  std_logic;
        in1     : in  std_logic;
        movei   : out std_logic;
        movei_2 : out std_logic;
        movei_3 : out std_logic;
        Bot1    : out std_logic;
        Bot2    : out std_logic;
        Bot3    : out std_logic
    );
end CSR_Lab_3_Part1_main;


architecture Structural of CSR_Lab_3_Part1_main is

  -------------------------------------------------------------------
  -- Component Declarations
  -------------------------------------------------------------------
  component CSR_Lab_3_Part1_TD1 is
    port(
      Clk : in std_logic;
      outi : in std_logic;
      ini : in std_logic;
      in1 : in std_logic;
      event_event74_td_1 : in std_logic;
      movei : out std_logic;
      Bot1 : out std_logic;
      out_evt_event71_td_2 : out std_logic;
      Enable : in std_logic;
      Reset : in std_logic
    );
  end component;

  component CSR_Lab_3_Part1_TD2 is
    port(
      Clk : in std_logic;
      ini : in std_logic;
      outi_2 : in std_logic;
      event_event71_td_2 : in std_logic;
      event_event90_td_2 : in std_logic;
      movei_2 : out std_logic;
      Bot1 : out std_logic;
      Bot2 : out std_logic;
      out_evt_event74_td_1 : out std_logic;
      out_evt_event87_td_3 : out std_logic;
      Enable : in std_logic;
      Reset : in std_logic
    );
  end component;

  component CSR_Lab_3_Part1_TD3 is
    port(
      Clk : in std_logic;
      ini_2 : in std_logic;
      outi_3 : in std_logic;
      ini_3 : in std_logic;
      event_event87_td_3 : in std_logic;
      movei_3 : out std_logic;
      Bot2 : out std_logic;
      Bot3 : out std_logic;
      out_evt_event90_td_2 : out std_logic;
      Enable : in std_logic;
      Reset : in std_logic
    );
  end component;

-------------------------------------------------------------------
  -- Updated LFSR24 with delay multiplier
  -------------------------------------------------------------------
  component LFSR24 is
    generic (
      MULT_SHIFT : integer := 8
    );
    port (
      Clk     : in  std_logic;
      Reset   : in  std_logic;
      Enable  : in  std_logic;
      evt_in  : in  std_logic;
      evt_out : out std_logic
    );
  end component;
  -------------------------------------------------------------------
  -- Internal signals
  -------------------------------------------------------------------
  signal Bot1_TD1, Bot1_TD2 : std_logic;
  signal Bot2_TD2, Bot2_TD3 : std_logic;
  signal Bot3_TD3           : std_logic;

  signal event_event74_td_1, event_event71_td_2, event_event90_td_2, event_event87_td_3 : std_logic;
  signal out_evt_event71_td_2, out_evt_event74_td_1, out_evt_event90_td_2, out_evt_event87_td_3 : std_logic;

  -- Random delay signals (each using its own LFSR24)
  signal rand_delay_TD1 : std_logic;
  signal rand_delay_TD2 : std_logic;
  signal rand_delay_TD3 : std_logic;

begin

  -------------------------------------------------------------------
  -- Random Delay Generators (LFSR24 with multipliers)
  -------------------------------------------------------------------

  -- TD2 → TD1 (moderate delay)
  U_LFSR_TD1 : LFSR24
    generic map (MULT_SHIFT => 8)   
    port map (
      Clk     => Clk,
      Reset   => Reset,
      Enable  => Enable,
      evt_in  => out_evt_event74_td_1,
      evt_out => event_event74_td_1
    );

  -- TD1 → TD2 (long delay)
  U_LFSR_TD2 : LFSR24
    generic map (MULT_SHIFT => 8)   -- 16× delay
    port map (
      Clk     => Clk,
      Reset   => Reset,
      Enable  => Enable,
      evt_in  => out_evt_event71_td_2,
      evt_out => event_event71_td_2
    );

  -- TD2 → TD3 (short delay)
  U_LFSR_TD3 : LFSR24
    generic map (MULT_SHIFT => 8)   -- 16× delay
    port map (
      Clk     => Clk,
      Reset   => Reset,
      Enable  => Enable,
      evt_in  => out_evt_event87_td_3,
      evt_out => event_event87_td_3
    );

  -- TD3 → TD2 (normal delay)
  U_LFSR_TD4 : LFSR24
    generic map (MULT_SHIFT => 8)   -- 16× delay
    port map (
      Clk     => Clk,
      Reset   => Reset,
      Enable  => Enable,
      evt_in  => out_evt_event90_td_2,
      evt_out => event_event90_td_2
    );
 -------------------------------------------------------------------
  -- TD1 instance
  -------------------------------------------------------------------
  U_TD1 : CSR_Lab_3_Part1_TD1
    port map (
      Clk => Clk,
      outi => outi,
      ini => ini,
      in1 => in1,
      event_event74_td_1 => event_event74_td_1, -- delayed TD2→TD1
      movei => movei,
      Bot1 => Bot1_TD1,
      out_evt_event71_td_2 => out_evt_event71_td_2, -- goes to TD2 through LFSR
      Enable => Enable,
      Reset => Reset
    );

  -------------------------------------------------------------------
  -- TD2 instance
  -------------------------------------------------------------------
  U_TD2 : CSR_Lab_3_Part1_TD2
    port map (
      Clk => Clk,
      ini => ini,
      outi_2 => outi_2,
      event_event71_td_2 => event_event71_td_2, -- delayed TD1→TD2
      event_event90_td_2 => event_event90_td_2, -- delayed TD3→TD2
      movei_2 => movei_2,
      Bot1 => Bot1_TD2,
      Bot2 => Bot2_TD2,
      out_evt_event74_td_1 => out_evt_event74_td_1, -- goes to TD1 through LFSR
      out_evt_event87_td_3 => out_evt_event87_td_3, -- goes to TD3 through LFSR
      Enable => Enable,
      Reset => Reset
    );

  -------------------------------------------------------------------
  -- TD3 instance
  -------------------------------------------------------------------
  U_TD3 : CSR_Lab_3_Part1_TD3
    port map (
      Clk => Clk,
      ini_2 => ini_2,
      outi_3 => outi_3,
      ini_3 => ini_3,
      event_event87_td_3 => event_event87_td_3, -- delayed TD2→TD3
      movei_3 => movei_3,
      Bot2 => Bot2_TD3,
      Bot3 => Bot3_TD3,
      out_evt_event90_td_2 => out_evt_event90_td_2, -- goes to TD2 through LFSR
      Enable => Enable,
      Reset => Reset
    );
  -------------------------------------------------------------------
  -- Combine outputs
  -------------------------------------------------------------------
  Bot1 <= Bot1_TD1 or Bot1_TD2;
  Bot2 <= Bot2_TD2 or Bot2_TD3;
  Bot3 <= Bot3_TD3;

end Structural;
