library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- matches your project style
use IEEE.NUMERIC_STD.ALL;

entity EventDelay is
  generic (
    WIDTH : integer := 28  -- number of LFSR bits used (delay 1..2^WIDTH)
  );
  port (
    Clk        : in  std_logic;
    Reset      : in  std_logic;
    Enable     : in  std_logic;
    lfsr_bits  : in  std_logic_vector(WIDTH-1 downto 0);
    evt_in     : in  std_logic;   -- 1-cycle pulse
    evt_out    : out std_logic    -- 1-cycle pulse, delayed
  );
end entity;

architecture rtl of EventDelay is
  signal busy     : std_logic := '0';
  signal cnt      : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
  signal evt_out_i: std_logic := '0';
  signal prev_in  : std_logic := '0';
  signal load_val : std_logic_vector(WIDTH-1 downto 0);
  constant ZERO_VEC : std_logic_vector(WIDTH-1 downto 0) := (others => '0');

begin
  evt_out <= evt_out_i;

  -- Rising edge detector on evt_in
  process(Clk)
  begin
    if rising_edge(Clk) then
      if Reset = '1' then
        prev_in   <= '0';
      else
        prev_in   <= evt_in;
      end if;
    end if;
  end process;

process(lfsr_bits)
begin
  if lfsr_bits = ZERO_VEC then
    load_val <= std_logic_vector(to_unsigned(1, WIDTH));
  else
    load_val <= lfsr_bits;
  end if;
end process;

  process(Clk)
  begin
    if rising_edge(Clk) then
      if Reset = '1' then
        busy      <= '0';
        cnt       <= (others => '0');
        evt_out_i <= '0';
      elsif Enable = '1' then
        evt_out_i <= '0'; -- default: no pulse

        if (busy = '0') then
          -- start a new delay on rising edge
          if (evt_in = '1' and prev_in = '0') then
            cnt  <= load_val;   -- 1..2^WIDTH-1 (or 1 if lfsr_bits=0)
            busy <= '1';
          end if;
        else
          -- counting down
          if cnt = ZERO_VEC then
            -- done: emit one-cycle pulse
            evt_out_i <= '1';
            busy      <= '0';
          else
            cnt <= cnt - 1;
          end if;
        end if;

      end if; -- Enable
    end if;   -- rising_edge
  end process;

end architecture;
