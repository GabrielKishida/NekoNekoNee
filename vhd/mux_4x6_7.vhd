LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_4x6_7 IS
    PORT (
        D0_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D0_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D0_2 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D0_3 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D0_4 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D0_5 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

        D1_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D1_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D1_2 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D1_3 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D1_4 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D1_5 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

        D2_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D2_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D2_2 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D2_3 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D2_4 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D2_5 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

        D3_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D3_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D3_2 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D3_3 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D3_4 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        D3_5 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

        SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

        MUX0_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        MUX1_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        MUX2_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        MUX3_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        MUX4_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        MUX5_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)

    );
END ENTITY;

ARCHITECTURE behav OF mux_4x6_7 IS
BEGIN
    MUX0_OUT <=
        D0_0 WHEN (SEL = "00") ELSE
        D1_0 WHEN (SEL = "01") ELSE
        D2_0 WHEN (SEL = "10") ELSE
        D3_0 WHEN (SEL = "11") ELSE
        "0000000";

    MUX1_OUT <=
        D0_1 WHEN (SEL = "00") ELSE
        D1_1 WHEN (SEL = "01") ELSE
        D2_1 WHEN (SEL = "10") ELSE
        D3_1 WHEN (SEL = "11") ELSE
        "0000000";

    MUX2_OUT <=
        D0_2 WHEN (SEL = "00") ELSE
        D1_2 WHEN (SEL = "01") ELSE
        D2_2 WHEN (SEL = "10") ELSE
        D3_2 WHEN (SEL = "11") ELSE
        "0000000";

    MUX3_OUT <=
        D0_3 WHEN (SEL = "00") ELSE
        D1_3 WHEN (SEL = "01") ELSE
        D2_3 WHEN (SEL = "10") ELSE
        D3_3 WHEN (SEL = "11") ELSE
        "0000000";

    MUX4_OUT <=
        D0_4 WHEN (SEL = "00") ELSE
        D1_4 WHEN (SEL = "01") ELSE
        D2_4 WHEN (SEL = "10") ELSE
        D3_4 WHEN (SEL = "11") ELSE
        "0000000";

    MUX5_OUT <=
        D0_5 WHEN (SEL = "00") ELSE
        D1_5 WHEN (SEL = "01") ELSE
        D2_5 WHEN (SEL = "10") ELSE
        D3_5 WHEN (SEL = "11") ELSE
        "0000000";
END behav;