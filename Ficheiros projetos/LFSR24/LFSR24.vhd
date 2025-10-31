library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ============================================================
--  LFSR24 with Scalable Random Delay
--  Polynomial: x^24 + x^23 + x^22 + x^17 + 1
--  MULT_SHIFT allows delay scaling by 2^MULT_SHIFT
-- ============================================================

entity LFSR24 is
  generic (
    MULT_SHIFT : integer := 0  -- left shift for scaling delay (0 = normal)
  );
  port (
    Clk     : in  std_logic;
    Reset   : in  std_logic;
    Enable  : in  std_logic;
    evt_in  : in  std_logic;
    evt_out : out std_logic
  );
end entity LFSR24;

architecture rtl of LFSR24 is
  -- 24-bit LFSR
  signal r        : std_logic_vector(23 downto 0) := (others => '0');

  -- 48-bit counter and load value to support large delays
  signal cnt      : unsigned(47 downto 0) := (others => '0');
  signal load_val : unsigned(47 downto 0) := (others => '0');

  signal busy     : std_logic := '0';
  signal evt_out_i: std_logic := '0';
  signal prev_in  : std_logic := '0';

  constant ZERO24 : std_logic_vector(23 downto 0) := (others => '0');
begin
  evt_out <= evt_out_i;

  -------------------------------------------------------------------
  -- Main Process: LFSR + Delay Counter
  -------------------------------------------------------------------
  process(Clk)
    variable fb        : std_logic;
    variable rand_val  : unsigned(23 downto 0);
  begin
    if rising_edge(Clk) then
      if Reset = '1' then
        -- Reset all internal registers
        r         <= (others => '0');
        r(0)      <= '1'; -- non-zero seed
        cnt       <= (others => '0');
        load_val  <= (others => '0');
        busy      <= '0';
        evt_out_i <= '0';
        prev_in   <= '0';

      elsif Enable = '1' then
        -------------------------------------------------------------------
        -- LFSR update
        -------------------------------------------------------------------
        fb := r(23) xor r(22) xor r(21) xor r(16);
        r  <= r(22 downto 0) & fb;

        evt_out_i <= '0';
        prev_in   <= evt_in;

        -------------------------------------------------------------------
        -- Event handling and delay generation
        -------------------------------------------------------------------
        if busy = '0' then
          -- Start a new delay on rising edge of evt_in
          if (evt_in = '1' and prev_in = '0') then

            -- ensure nonzero random value
            if r = ZERO24 then
              rand_val := to_unsigned(1, 24);
            else
              rand_val := unsigned(r);
            end if;

            -- scale delay by 2^MULT_SHIFT and resize to 48 bits
            load_val <= resize(shift_left(rand_val, MULT_SHIFT), load_val'length);

            -- load counter
            cnt  <= load_val;
            busy <= '1';
          end if;

        else
          -- Counting down
          if cnt = to_unsigned(0, cnt'length) then
            evt_out_i <= '1';
            busy      <= '0';
          else
            cnt <= cnt - 1;
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture rtl;
ure rtl;
