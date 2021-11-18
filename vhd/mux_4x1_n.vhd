LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_4x1_n IS
    PORT (
        D0 : IN STD_LOGIC;
        D1 : IN STD_LOGIC;
        D2 : IN STD_LOGIC;
        D3 : IN STD_LOGIC;
        SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        MUX_OUT : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behav OF mux_4x1_n IS
BEGIN
    MUX_OUT <= D3 WHEN (SEL = "11") ELSE
        D2 WHEN (SEL = "10") ELSE
        D1 WHEN (SEL = "01") ELSE
        D0 WHEN (SEL = "00") ELSE
        '1';
END behav;