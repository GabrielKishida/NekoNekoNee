LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY neko_neko_nee_tb IS
END ENTITY;

ARCHITECTURE tb OF neko_neko_nee_tb IS

    -- Componente a ser testado (Device Under Test -- DUT)
    COMPONENT neko_neko_nee IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            echo : IN STD_LOGIC;
            disponivel : IN STD_LOGIC;
            tamanho_porcao : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            trigger : OUT STD_LOGIC;
            indisponivel : OUT STD_LOGIC;
            pwm : OUT STD_LOGIC;
            db_pwm : OUT STD_LOGIC;
            db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            db_tamanho_porcao : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            db_medida_sseg0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_medida_sseg1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_medida_sseg2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            db_estado_uc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            db_estado_uc_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_aberto : OUT STD_LOGIC;
            db_estado_interface : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            db_estado_interface_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_estado_despensa : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
        );
    END COMPONENT;

    -- Declaração de sinais para conectar o componente a ser testado (DUT)
    --   valores iniciais para fins de simulacao (ModelSim)
    SIGNAL clock_in : STD_LOGIC := '0';
    SIGNAL reset_in : STD_LOGIC := '0';
    SIGNAL echo_in : STD_LOGIC := '0';
    SIGNAL disponivel_in : STD_LOGIC := '0';
    SIGNAL tamanho_porcao_in : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
    SIGNAL trigger_out : STD_LOGIC := '0';
    SIGNAL indisponivel_out : STD_LOGIC := '0';
    SIGNAL pwm_out : STD_LOGIC;
    SIGNAL db_posicao_out : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL db_medida_out : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL db_estado_uc_out : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
    SIGNAL db_aberto_out : STD_LOGIC := '0';
    SIGNAL db_estado_interface_out : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
    SIGNAL db_estado_despensa_out : STD_LOGIC_VECTOR (1 DOWNTO 0);

    -- Configurações do clock
    SIGNAL keep_simulating : STD_LOGIC := '0'; -- delimita o tempo de geração do clock
    CONSTANT clockPeriod : TIME := 20 ns; -- clock de 50MHz

BEGIN
    -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período
    -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
    -- simulação de eventos
    clock_in <= (NOT clock_in) AND keep_simulating AFTER clockPeriod/2;

    -- Conecta DUT (Device Under Test)
    dut : neko_neko_nee
    PORT MAP
    (
        clock => clock_in,
        reset => reset_in,
        echo => echo_in,
        disponivel => disponivel_in,
        tamanho_porcao => tamanho_porcao_in,
        trigger => trigger_out,
        indisponivel => indisponivel_out,
        pwm => pwm_out,
        db_pwm => OPEN,
        db_posicao => db_posicao_out,
        db_tamanho_porcao => OPEN,
        db_medida_sseg0 => OPEN,
        db_medida_sseg1 => OPEN,
        db_medida_sseg2 => OPEN,
        db_medida => db_medida_out,
        db_estado_uc => db_estado_uc_out,
        db_estado_uc_sseg => OPEN,
        db_aberto => db_aberto_out,
        db_estado_interface => db_estado_interface_out,
        db_estado_interface_sseg => OPEN,
        db_estado_despensa => db_estado_despensa_out
    );

    -- geracao dos sinais de entrada (estimulos)
    stimulus : PROCESS IS
    BEGIN

        ASSERT false REPORT "Inicio da simulacao" SEVERITY note;
        keep_simulating <= '1';

        ---- inicio da simulacao: reset ----------------
        reset_in <= '1';
        WAIT FOR 20 * clockPeriod; -- pulso com 20 periodos de clock
        reset_in <= '0';
        WAIT UNTIL falling_edge(clock_in);
        WAIT FOR 50 * clockPeriod;

        -- TAMANHO 00 (BABY)
        tamanho_porcao_in <= "00";

        -- CASOS SEM DISPONIBILIDADE

        disponivel_in <= '0';

        ---- caso de teste #1 chegar no checa disponivel e nao estar disponivel
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        -- CASO DE TESTES #2  nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        WAIT FOR 10 * clockPeriod;

        -- CASOS COM DISPONIBILIDADE

        disponivel_in <= '1';

        ---- caso de teste #3 abrir despensa
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        -- CASO DE TESTES #4 nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        -- INTERVALO
        WAIT FOR 10000 * clockPeriod;

        -- TAMANHO 01 (SMALL)
        tamanho_porcao_in <= "01";

        -- CASOS SEM DISPONIBILIDADE

        disponivel_in <= '0';

        ---- caso de teste #1 chegar no checa disponivel e nao estar disponivel
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        -- CASO DE TESTES #2  nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        WAIT FOR 10 * clockPeriod;

        -- CASOS COM DISPONIBILIDADE

        disponivel_in <= '1';

        ---- caso de teste #3 abrir despensa
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        -- CASO DE TESTES #4 nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        -- INTERVALO
        WAIT FOR 10000 * clockPeriod;

        -- TAMANHO 10 (MEDIUM)

        tamanho_porcao_in <= "10";

        -- CASOS SEM DISPONIBILIDADE

        disponivel_in <= '0';

        ---- caso de teste #1 chegar no checa disponivel e nao estar disponivel
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        -- CASO DE TESTES #2  nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        WAIT FOR 10 * clockPeriod;

        -- CASOS COM DISPONIBILIDADE

        disponivel_in <= '1';

        ---- caso de teste #3 abrir despensa
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        -- CASO DE TESTES #4 nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        -- INTERVALO

        WAIT FOR 10000 * clockPeriod;

        -- TAMANHO 11 (BIG)

        tamanho_porcao_in <= "11";

        -- CASOS SEM DISPONIBILIDADE

        disponivel_in <= '0';

        ---- caso de teste #1 chegar no checa disponivel e nao estar disponivel
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        -- CASO DE TESTES #2  nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        WAIT FOR 10 * clockPeriod;

        -- CASOS COM DISPONIBILIDADE

        disponivel_in <= '1';

        ---- caso de teste #3 abrir despensa
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 12000 * clockPeriod; -- DISTANCIA DE 4 CM
        echo_in <= '0';

        -- CASO DE TESTES #4 nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        -- INTERVALO
        WAIT FOR 10000 * clockPeriod;

        ---- final dos casos de teste da simulacao
        ASSERT false REPORT "fim da simulacao" SEVERITY note;
        keep_simulating <= '0';

        WAIT; -- fim da simulação: aguarda indefinidamente
    END PROCESS;
END ARCHITECTURE;