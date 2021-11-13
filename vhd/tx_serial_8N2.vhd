LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY tx_serial_8N2 IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        partida : IN STD_LOGIC;
        dados_ascii : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        saida_serial : OUT STD_LOGIC;
        pronto_tx : OUT STD_LOGIC;
        db_partida : OUT STD_LOGIC;
        db_saida_serial : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE tx_serial_8N2_arch OF tx_serial_8N2 IS

    COMPONENT tx_serial_tick_uc PORT (
        clock, reset, partida, tick, fim : IN STD_LOGIC;
        zera, conta, carrega, desloca, pronto : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT tx_serial_8N2_fd PORT (
        clock, reset : IN STD_LOGIC;
        zera, conta, carrega, desloca : IN STD_LOGIC;
        dados_ascii : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        saida_serial, fim : OUT STD_LOGIC;
        db_deslocado : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT contador_m
        GENERIC (
            CONSTANT M : INTEGER
        );
        PORT (
            clock, zera_as, zera_s, conta : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
            fim, meio : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL s_reset : STD_LOGIC;
    SIGNAL s_zera, s_conta, s_carrega, s_desloca, s_tick, s_fim : STD_LOGIC;
    SIGNAL s_saida_serial : STD_LOGIC;

    SIGNAL s_db_deslocado : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL s_db_estado_hex_in : STD_LOGIC_VECTOR (3 DOWNTO 0);

BEGIN

    -- sinais reset e partida mapeados na GPIO (ativos em alto)
    s_reset <= reset;

    -- unidade de controle
    U1_UC : tx_serial_tick_uc PORT MAP(
        clock, s_reset, partida, s_tick, s_fim,
        s_zera, s_conta, s_carrega, s_desloca, pronto_tx, db_estado);

    -- fluxo de dados
    U2_FD : tx_serial_8N2_fd PORT MAP(
        clock, s_reset, s_zera, s_conta, s_carrega, s_desloca,
        dados_ascii, s_saida_serial, s_fim, s_db_deslocado);

    -- gerador de tick
    -- fator de divisao 50MHz para 9600 bauds (5208=50M/9600)
    U3_TICK : contador_m GENERIC MAP(M => 5208) PORT MAP(clock, s_zera, '0', '1', OPEN, s_tick, OPEN);

    saida_serial <= s_saida_serial;
    db_saida_serial <= s_saida_serial;
    db_partida <= partida;
END ARCHITECTURE;