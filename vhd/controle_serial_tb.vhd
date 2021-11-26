LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controle_serial_tb IS
END ENTITY;

ARCHITECTURE tb OF controle_serial_tb IS
    COMPONENT controle_serial
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

    -- Declaração de sinais para conectar o componente a ser testado (DUT)
    --   valores iniciais para fins de simulacao (ModelSim)
    SIGNAL clock_in : STD_LOGIC := '0';
    SIGNAL reset_in : STD_LOGIC := '0';
    SIGNAL alimentou_in : STD_LOGIC := '0';
    SIGNAL n_alimentou_in : STD_LOGIC := '0';
    SIGNAL horas_in : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
    SIGNAL minutos_in : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
    SIGNAL dado_recebido_rx_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL saida_serial_out : STD_LOGIC;
    SIGNAL pronto_out : STD_LOGIC;
    SIGNAL db_estado_tx_out : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL db_estado_uc_out : STD_LOGIC_VECTOR (2 DOWNTO 0);

    -- Configurações do clock
    SIGNAL keep_simulating : STD_LOGIC := '0'; -- delimita o tempo de geração do clock
    CONSTANT clockPeriod : TIME := 20 ns; -- clock de 50MHz

BEGIN
    -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período
    -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
    -- simulação de eventos
    clock_in <= (NOT clock_in) AND keep_simulating AFTER clockPeriod/2;

    -- Conecta DUT (Device Under Test)
    DUT : controle_serial PORT MAP(
        clock => clock_in,
        reset => reset_in,
        horas => horas_in,
        minutos => minutos_in,
        alimentou => alimentou_in,
        n_alimentou => n_alimentou_in,
        saida_serial => saida_serial_out,
        pronto => pronto_out,
        db_saida_serial => OPEN,
        db_estado_uc => db_estado_uc_out,
        db_estado_tx => db_estado_tx_out
    );

    UART_RX : uart_8n2 PORT MAP(
        clock => clock_in,
        reset => reset_in,
        transmite_dado => '0',
        dados_ascii => "00000000",
        dado_serial => saida_serial_out,
        recebe_dado => '1',
        saida_serial => OPEN,
        pronto_tx => OPEN,
        dado_recebido_rx => dado_recebido_rx_out,
        tem_dado => OPEN,
        pronto_rx => OPEN,
        db_transmite_dado => OPEN,
        db_saida_serial => OPEN,
        db_estado_tx => OPEN,
        db_partida => OPEN,
        db_recebe_dado => OPEN,
        db_dado_serial => OPEN,
        db_estado_rx => OPEN
    );
    -- geracao dos sinais de entrada (estimulos)
    stimulus : PROCESS IS
    BEGIN

        ASSERT false REPORT "Inicio da simulacao" SEVERITY note;
        keep_simulating <= '1';

        reset_in <= '1';
        WAIT FOR 10 * clockPeriod;
        reset_in <= '0';

        horas_in <= "00010111"; -- 17
        minutos_in <= "00110000"; -- 30

        WAIT FOR 10 * clockPeriod;

        alimentou_in <= '1';
        WAIT FOR 5 * clockPeriod;
        alimentou_in <= '0';

        WAIT UNTIL pronto_out = '1';

        WAIT FOR 100 * clockPeriod;

        horas_in <= "00100001"; -- 21
        minutos_in <= "01000101"; -- 45

        WAIT FOR 10 * clockPeriod;

        n_alimentou_in <= '1';
        WAIT FOR 5 * clockPeriod;
        n_alimentou_in <= '0';

        WAIT UNTIL pronto_out = '1';

        WAIT FOR 100 * clockPeriod;

        ---- final dos casos de teste da simulacao
        ASSERT false REPORT "fim da simulacao" SEVERITY note;
        keep_simulating <= '0';

        WAIT; -- fim da simulação: aguarda indefinidamente
    END PROCESS;
END ARCHITECTURE;