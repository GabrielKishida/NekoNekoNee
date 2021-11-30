
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY controle_serial IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        horas : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        minutos : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        alimentou : IN STD_LOGIC;
        n_alimentou : IN STD_LOGIC;
        saida_serial : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        db_saida_serial : OUT STD_LOGIC;
        db_estado_uc : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        db_estado_tx : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE controle_serial_arch OF controle_serial IS

    COMPONENT controle_serial_uc
        PORT (
            clock, reset : IN STD_LOGIC;
            alimentou : IN STD_LOGIC;
            n_alimentou : IN STD_LOGIC;
            fim_tx : IN STD_LOGIC;
            fim_contagem : IN STD_LOGIC;
            zera : OUT STD_LOGIC;
            enviar_palavra : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC;
            conta : OUT STD_LOGIC;
            ocorreu_alimentacao : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            db_estado : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
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

    COMPONENT mux_8x1_8 IS
        PORT (
            D0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D5 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D6 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D7 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            SEL : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            MUX_OUT : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT uart_8N2 IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            transmite_dado : IN STD_LOGIC;
            dados_ascii : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            dado_serial : IN STD_LOGIC;
            recebe_dado : IN STD_LOGIC;
            saida_serial : OUT STD_LOGIC;
            pronto_tx : OUT STD_LOGIC;
            dado_recebido_rx : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            tem_dado : OUT STD_LOGIC;
            pronto_rx : OUT STD_LOGIC;
            db_transmite_dado : OUT STD_LOGIC;
            db_saida_serial : OUT STD_LOGIC;
            db_estado_tx : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            db_partida : OUT STD_LOGIC;
            db_recebe_dado : OUT STD_LOGIC;
            db_dado_serial : OUT STD_LOGIC;
            db_estado_rx : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL s_pronto_tx, s_fim_contagem, s_enviar_palavra, s_zera, s_conta : STD_LOGIC;
    SIGNAL s_ocorreu_alimentacao : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL asc_hora1, asc_hora0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL asc_minuto1, asc_minuto0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL s_a_transmitir : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_contagem : STD_LOGIC_VECTOR (2 DOWNTO 0);
BEGIN

    asc_hora1 <= "0011" & horas(7 DOWNTO 4);
    asc_hora0 <= "0011" & horas(3 DOWNTO 0);
    asc_minuto1 <= "0011" & minutos(7 DOWNTO 4);
    asc_minuto0 <= "0011" & minutos(3 DOWNTO 0);

    CTRL_SERIAL_UC : controle_serial_uc PORT MAP(
        clock => clock,
        reset => reset,
        alimentou => alimentou,
        n_alimentou => n_alimentou,
        fim_tx => s_pronto_tx,
        fim_contagem => s_fim_contagem,
        zera => s_zera,
        enviar_palavra => s_enviar_palavra,
        pronto => pronto,
        conta => s_conta,
        ocorreu_alimentacao => s_ocorreu_alimentacao,
        db_estado => db_estado_uc
    );

    UART : uart_8n2 PORT MAP(
        clock => clock,
        reset => reset,
        transmite_dado => s_enviar_palavra,
        dados_ascii => s_a_transmitir,
        dado_serial => '0',
        recebe_dado => '0',
        saida_serial => saida_serial,
        pronto_tx => s_pronto_tx,
        dado_recebido_rx => OPEN,
        tem_dado => OPEN,
        pronto_rx => OPEN,
        db_transmite_dado => OPEN,
        db_saida_serial => db_saida_serial,
        db_estado_tx => db_estado_tx,
        db_partida => OPEN,
        db_recebe_dado => OPEN,
        db_dado_serial => OPEN,
        db_estado_rx => OPEN
    );

    MUX_SERIAL : mux_8x1_8 PORT MAP(
        D0 => s_ocorreu_alimentacao,
        D1 => asc_hora1,
        D2 => asc_hora0,
        D3 => "00111010",
        D4 => asc_minuto1,
        D5 => asc_minuto0,
        D6 => "00101110",
        D7 => "00000000",
        SEL => s_contagem,
        MUX_OUT => s_a_transmitir
    );

    CONTADOR : contador_m GENERIC MAP(
        m => 7) PORT MAP(
        clock => clock,
        zera_as => s_zera,
        zera_s => s_zera,
        conta => s_conta,
        Q => s_contagem,
        fim => s_fim_contagem,
        meio => OPEN
    );

END ARCHITECTURE;