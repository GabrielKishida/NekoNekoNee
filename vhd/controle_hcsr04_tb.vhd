LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controle_hcsr04_tb IS
END ENTITY;

ARCHITECTURE tb OF controle_hcsr04_tb IS

    -- Componente a ser testado (Device Under Test -- DUT)
    COMPONENT controle_hcsr04
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            echo : IN STD_LOGIC;
            disponivel : IN STD_LOGIC;
            aberto : IN STD_LOGIC;
            trigger : OUT STD_LOGIC;
            indisponivel : OUT STD_LOGIC;
            abre : OUT STD_LOGIC;
            medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            db_estado_uc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            db_estado_interface : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    -- Declaração de sinais para conectar o componente a ser testado (DUT)
    --   valores iniciais para fins de simulacao (ModelSim)
    SIGNAL clock_in : STD_LOGIC := '0';
    SIGNAL reset_in : STD_LOGIC := '0';
    SIGNAL echo_in : STD_LOGIC := '0';
    SIGNAL disponivel_in : STD_LOGIC := '0';
    SIGNAL aberto_in : STD_LOGIC := '0';
    SIGNAL trigger_out : STD_LOGIC := '0';
    SIGNAL indisponivel_out : STD_LOGIC := '0';
    SIGNAL abre_out : STD_LOGIC := '0';
    SIGNAL medida_out : STD_LOGIC_VECTOR (11 DOWNTO 0) := "000000000000";
    SIGNAL db_estado_uc_out : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
    SIGNAL db_aberto_out : STD_LOGIC := '0';
    SIGNAL db_estado_interface_out : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";

    -- Configurações do clock
    SIGNAL keep_simulating : STD_LOGIC := '0'; -- delimita o tempo de geração do clock
    CONSTANT clockPeriod : TIME := 20 ns; -- clock de 50MHz

BEGIN
    -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período
    -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
    -- simulação de eventos
    clock_in <= (NOT clock_in) AND keep_simulating AFTER clockPeriod/2;

    -- Conecta DUT (Device Under Test)
    dut : controle_hcsr04
    PORT MAP
    (
        clock => clock_in,
        reset => reset_in,
        echo => echo_in,
        disponivel => disponivel_in,
        aberto => aberto_in,
        trigger => trigger_out,
        indisponivel => indisponivel_out,
        abre => abre_out,
        medida => medida_out,
        db_estado_uc => db_estado_uc_out,
        db_estado_interface => db_estado_interface_out

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

        aberto_in <= '1';
        WAIT FOR 10000 * clockPeriod;
        aberto_in <= '0';

        -- CASO DE TESTES #4 nao detectar objeto
        WAIT UNTIL trigger_out = '1';
        WAIT UNTIL trigger_out = '0';
        WAIT FOR 10000 * clockPeriod;
        echo_in <= '1';
        WAIT UNTIL rising_edge(clock_in);
        WAIT FOR 148000 * clockPeriod; -- 50 cm
        echo_in <= '0';

        WAIT FOR 10000 * clockPeriod;

        ---- final dos casos de teste da simulacao
        ASSERT false REPORT "fim da simulacao" SEVERITY note;
        keep_simulating <= '0';

        WAIT; -- fim da simulação: aguarda indefinidamente
    END PROCESS;
END ARCHITECTURE;