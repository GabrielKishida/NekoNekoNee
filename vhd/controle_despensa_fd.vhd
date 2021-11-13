LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY controle_despensa_fd IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable_reg : IN STD_LOGIC;
        posicao : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        tamanho_porcao : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        tamanho_porcao_reg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
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

    SIGNAL s_saida_serial : STD_LOGIC;

BEGIN
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
        Q => tamanho_porcao_reg
    );
END ARCHITECTURE;