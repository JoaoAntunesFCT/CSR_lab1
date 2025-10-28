-- 24-bit Fibonacci LFSR with seed=1
-- Polynomial: x^24 + x^23 + x^22 + x^17 + 1
-- Taps: 24, 23, 22, 17  (bit indices 23,22,21,16 in VHDL 0-based)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSR24 is
  port (
    Clk    : in  std_logic;
    Reset  : in  std_logic;     -- async or sync as you prefer; here sync reset
    Enable : in  std_logic;
    Q      : out std_logic_vector(23 downto 0)
  );
end entity;

architecture rtl of LFSR24 is
  signal r : std_logic_vector(23 downto 0);
begin
  process(Clk)
    variable fb : std_logic;
  begin
    if rising_edge(Clk) then
      if Reset = '1' then
        -- seed = 1
        r <= (others => '0');
        r(0) <= '1'; --seed
      elsif Enable = '1' then
        -- feedback = XOR of taps (23,22,21,16) using 0-based indexing
        fb := r(23) xor r(22) xor r(21) xor r(16);
        r  <= r(22 downto 0) & fb;
      end if;
    end if;
  end process;

  Q <= r;
end architecture;
