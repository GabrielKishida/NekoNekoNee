LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY controle_despensa_fd IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable_reg : IN STD_LOGIC;
        conta : IN STD_LOGIC;
        zera : IN STD_LOGIC;
        posicao : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        tamanho_porcao : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        fim : OUT STD_LOGIC;
        db_tamanho_porcao : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        pwm : OUT STD_LOGIC;
        db_pwm : OUT STD_LOGIC;
        db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE controle_despensa_fd_arch OF controle_despensa_fd IS

    COMPONENT controle_servo IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            posicao : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            pwm : OUT STD_LOGIC;
            db_pwm : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT registrador_2bits IS
        PORT (
            clock : IN STD_LOGIC;
            clear : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT contador_m IS
        GENERIC (
            CONSTANT M : INTEGER := 50 -- modulo do contador
        );
        PORT (
            clock, zera_as, zera_s, conta : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
            fim, meio : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mux_4x1_n IS
        PORT (
            D0 : IN STD_LOGIC;
            D1 : IN STD_LOGIC;
            D2 : IN STD_LOGIC;
            D3 : IN STD_LOGIC;
            SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            MUX_OUT : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL baby_fim, small_fim, medium_fim, big_fim, s_fim : STD_LOGIC;
    SIGNAL s_tamanho_porcao_reg : STD_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN

    CONTADOR_BABY : contador_m GENERIC MAP(
        M => 50000000) PORT MAP (
        clock,
        reset,
        zera,
        conta,
        OPEN,
        baby_fim,
        OPEN
    );

    CONTADOR_SMALL : contador_m GENERIC MAP(
        M => 75000000) PORT MAP (
        clock,
        reset,
        zera,
        conta,
        OPEN,
        small_fim,
        OPEN
    );

    CONTADOR_MEDIUM : contador_m GENERIC MAP(
        M => 100000000) PORT MAP (
        clock,
        reset,
        zera,
        conta,
        OPEN,
        medium_fim,
        OPEN
    );

    CONTADOR_BIG : contador_m GENERIC MAP(
        M => 150000000) PORT MAP (
        clock,
        reset,
        zera,
        conta,
        OPEN,
        big_fim,
        OPEN
    );

    MUX_CONTADORES : mux_4x1_n PORT MAP(
        baby_fim,
        small_fim,
        medium_fim,
        big_fim,
        s_tamanho_porcao_reg,
        fim
    );

    CONTROLE_SERVO : controle_servo PORT MAP(
        clock => clock,
        reset => reset,
        posicao => posicao,
        db_posicao => db_posicao,
        pwm => pwm,
        db_pwm => db_pwm
    );

    REG2BITS : registrador_2bits
    PORT MAP(
        clock => clock,
        clear => reset,
        enable => enable_reg,
        D => tamanho_porcao,
        Q => s_tamanho_porcao_reg
    );
END ARCHITECTURE;