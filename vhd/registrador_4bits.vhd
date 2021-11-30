LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registrador_4bits IS
  PORT (
    clock : IN STD_LOGIC;
    clear : IN STD_LOGIC;
    enable : IN STD_LOGIC;
    D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF registrador_4bits IS
  SIGNAL IQ : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
  PROCESS (clock, clear, IQ)
  BEGIN
    IF (clear = '1') THEN
      IQ <= (OTHERS => '0');
    ELSIF (clock'event AND clock = '1') THEN
      IF (enable = '1') THEN
        IQ <= D;
      END IF;
    END IF;
  END PROCESS;

  Q <= IQ;
END ARCHITECTURE;