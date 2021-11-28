LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY timer_fd IS
    PORT (
        clock, reset, conta_alimentacao, configura, atualiza : IN STD_LOGIC;
        periodo : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        i_dig5, i_dig4, i_dig3, i_dig2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        dig5, dig4, dig3, dig2, dig1, dig0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        horario : OUT STD_LOGIC;
        db_segundo : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch OF timer_fd IS

    COMPONENT contador_timer
        PORT (
            clock, zera, conta, registra : IN STD_LOGIC;
            i_dig5, i_dig4, i_dig3, i_dig2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            dig5, dig4, dig3, dig2, dig1, dig0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            fim : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT registrador_n
        GENERIC (
            CONSTANT N : INTEGER
        );
        PORT (
            clock : IN STD_LOGIC;
            clear : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT divisor_timer
        PORT (
            clock, zera_as, zera_s, conta : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(100)))) - 1 DOWNTO 0);
            fim, meio : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT contador_alimentacao
        PORT (
            clock, zera_as, zera_s, conta : IN STD_LOGIC;
            teto : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            fim : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL s_conta_alimentacao, s_fim_periodo, s_segundo, s_configura, s_reg_periodo, s_reg_atualiza : STD_LOGIC;
    SIGNAL s_dig5, s_dig4, s_dig3, s_dig2, s_dig1, s_dig0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_periodo, s_horario : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_distancia : STD_LOGIC_VECTOR(11 DOWNTO 0);

BEGIN

    CONTAGEM_ALIMENTACAO : contador_alimentacao
    PORT MAP(
        clock,
        reset,
        '0',
        s_conta_alimentacao,
        s_horario,
        s_fim_periodo
    );

    REGISTRADOR_PERIODO : registrador_n GENERIC MAP(
        N => 4) PORT MAP(
        clock,
        reset,
        s_reg_periodo,
        s_periodo,
        s_horario
    );

    DIVISOR : divisor_timer
    PORT MAP(
        clock,
        reset,
        '0',
        '1',
        OPEN,
        s_segundo,
        OPEN

    );

    RELOGIO : contador_timer
    PORT MAP(
        clock,
        reset,
        s_segundo,
        s_configura,
        i_dig5,
        i_dig4,
        i_dig3,
        i_dig2,
        s_dig5,
        s_dig4,
        s_dig3,
        s_dig2,
        s_dig1,
        s_dig0,
        OPEN
    );

    dig5 <= s_dig5;
    dig4 <= s_dig4;
    dig3 <= s_dig3;
    dig2 <= s_dig2;
    dig1 <= s_dig1;
    dig0 <= s_dig0;
    horario <= s_fim_periodo;
    s_configura <= configura;
    s_reg_atualiza <= atualiza;
    s_periodo <= periodo;
    s_conta_alimentacao <= conta_alimentacao;
    s_reg_periodo <= s_reg_atualiza OR s_configura;
    db_segundo <= s_segundo;

END ARCHITECTURE;