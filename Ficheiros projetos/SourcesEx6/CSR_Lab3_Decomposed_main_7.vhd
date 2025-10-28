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

  component LFSR24 is
    port (
      Clk    : in  std_logic;
      Reset  : in  std_logic;
      Enable : in  std_logic;
      Q      : out std_logic_vector(23 downto 0)
    );
  end component;

  component EventDelay is
    generic (
      WIDTH : integer := 4
    );
    port (
      Clk       : in  std_logic;
      Reset     : in  std_logic;
      Enable    : in  std_logic;
      lfsr_bits : in  std_logic_vector(WIDTH-1 downto 0);
      evt_in    : in  std_logic;
      evt_out   : out std_logic
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

  signal lfsr_q : std_logic_vector(23 downto 0);

  -- delayed versions of the inter-TD events
  signal delayed_event74, delayed_event71, delayed_event87, delayed_event90 : std_logic;

begin

  -------------------------------------------------------------------
  -- LFSR (pseudo-random generator)
  -------------------------------------------------------------------
  U_LFSR : LFSR24
    port map (
      Clk    => Clk,
      Reset  => Reset,
      Enable => Enable,
      Q      => lfsr_q
    );

  -------------------------------------------------------------------
  -- Event Delay Instances (insert between TD blocks)
  -------------------------------------------------------------------
  -- Delay event from TD2 → TD1
  U_Delay74 : EventDelay
    generic map ( WIDTH => 4 )
    port map (
      Clk       => Clk,
      Reset     => Reset,
      Enable    => Enable,
      lfsr_bits => lfsr_q(3 downto 0),
      evt_in    => out_evt_event74_td_1,
      evt_out   => delayed_event74
    );

  -- Delay event from TD1 → TD2
  U_Delay71 : EventDelay
    generic map ( WIDTH => 4 )
    port map (
      Clk       => Clk,
      Reset     => Reset,
      Enable    => Enable,
      lfsr_bits => lfsr_q(7 downto 4),
      evt_in    => out_evt_event71_td_2,
      evt_out   => delayed_event71
    );

  -- Delay event from TD2 → TD3
  U_Delay87 : EventDelay
    generic map ( WIDTH => 4 )
    port map (
      Clk       => Clk,
      Reset     => Reset,
      Enable    => Enable,
      lfsr_bits => lfsr_q(11 downto 8),
      evt_in    => out_evt_event87_td_3,
      evt_out   => delayed_event87
    );

  -- Delay event from TD3 → TD2
  U_Delay90 : EventDelay
    generic map ( WIDTH => 4 )
    port map (
      Clk       => Clk,
      Reset     => Reset,
      Enable    => Enable,
      lfsr_bits => lfsr_q(15 downto 12),
      evt_in    => out_evt_event90_td_2,
      evt_out   => delayed_event90
    );

  -------------------------------------------------------------------
  -- TD1
  -------------------------------------------------------------------
  U_TD1 : CSR_Lab_3_Part1_TD1
    port map (
      Clk => Clk,
      outi => outi,
      ini => ini,
      in1 => in1,
      event_event74_td_1 => delayed_event74, -- use delayed version
      movei => movei,
      Bot1 => Bot1_TD1,
      out_evt_event71_td_2 => out_evt_event71_td_2,
      Enable => Enable,
      Reset => Reset
    );

  -------------------------------------------------------------------
  -- TD2
  -------------------------------------------------------------------
  U_TD2 : CSR_Lab_3_Part1_TD2
    port map (
      Clk => Clk,
      ini => ini,
      outi_2 => outi_2,
      event_event71_td_2 => delayed_event71,
      event_event90_td_2 => delayed_event90,
      movei_2 => movei_2,
      Bot1 => Bot1_TD2,
      Bot2 => Bot2_TD2,
      out_evt_event74_td_1 => out_evt_event74_td_1,
      out_evt_event87_td_3 => out_evt_event87_td_3,
      Enable => Enable,
      Reset => Reset
    );

  -------------------------------------------------------------------
  -- TD3
  -------------------------------------------------------------------
  U_TD3 : CSR_Lab_3_Part1_TD3
    port map (
      Clk => Clk,
      ini_2 => ini_2,
      outi_3 => outi_3,
      ini_3 => ini_3,
      event_event87_td_3 => delayed_event87,
      movei_3 => movei_3,
      Bot2 => Bot2_TD3,
      Bot3 => Bot3_TD3,
      out_evt_event90_td_2 => out_evt_event90_td_2,
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
