LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY timer_tb IS
END ENTITY;

ARCHITECTURE tb OF timer_tb IS

    -- Componente a ser testado (Device Under Test -- DUT)
    COMPONENT timer IS
        PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        configura : IN STD_LOGIC;
        mais : IN STD_LOGIC;
        alimentado : IN STD_LOGIC;
        periodo : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        dig5, dig4, dig3, dig2, dig1, dig0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        db_dig5, db_dig4, db_dig3, db_dig2, db_dig1, db_dig0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        disponivel : OUT STD_LOGIC;
        salva : OUT STD_LOGIC;
	configurando : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_segundo : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Declaração de sinais para conectar o componente a ser testado (DUT)
    --   valores iniciais para fins de simulacao (ModelSim)
    SIGNAL clock_in : STD_LOGIC := '0';
    SIGNAL reset_in : STD_LOGIC := '0';
    SIGNAL configura_in : STD_LOGIC := '0';
    SIGNAL mais_in : STD_LOGIC := '0';
    SIGNAL alimentado_in : STD_LOGIC := '0';
    SIGNAL periodo_in : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
    SIGNAL dig5_out, dig4_out, dig3_out, dig2_out, dig1_out, dig0_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL db_dig5_out, db_dig4_out, db_dig3_out, db_dig2_out, db_dig1_out, db_dig0_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL disponibiliza_out : STD_LOGIC := '0';
    SIGNAL salva_out : STD_LOGIC := '0';
    SIGNAL configurando_out : STD_LOGIC := '0';
    SIGNAL db_estado_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_segundo_out : STD_LOGIC := '0';

    -- Configurações do clock
    SIGNAL keep_simulating : STD_LOGIC := '0'; -- delimita o tempo de geração do clock
    CONSTANT clockPeriod : TIME := 20 ns; -- clock de 50MHz

BEGIN
    -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período
    -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
    -- simulação de eventos
    clock_in <= (NOT clock_in) AND keep_simulating AFTER clockPeriod/2;

    -- Conecta DUT (Device Under Test)
    dut : timer
    PORT MAP
    (
        clock_in,
        reset_in,
        configura_in,
	mais_in,
        alimentado_in,
        periodo_in,
        dig5_out,
        dig4_out,
        dig3_out,
        dig2_out,
        dig1_out,
        dig0_out,
        db_dig5_out,
        db_dig4_out,
        db_dig3_out,
        db_dig2_out,
        db_dig1_out,
        db_dig0_out,
        disponibiliza_out,
        salva_out,
	configurando_out,
        db_estado_out,
        db_segundo_out
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

        ---- setando os valores iniciais Horario: 16:43 Periodo: 4 horas
        periodo_in <= "0100";

        ---- Testa permanencia no estado inicial
        WAIT FOR 10 * clockPeriod;

	mais_in <= '1';
	wait for clockPeriod;
	mais_in <= '0';

	wait for clockPeriod;

        configura_in <= '1';
        WAIT FOR clockPeriod;
        configura_in <= '0';

	configura_in <= '1';
        WAIT FOR clockPeriod;
        configura_in <= '0';

	wait for clockPeriod;

	configura_in <= '1';
        WAIT FOR clockPeriod;
        configura_in <= '0';

	wait for clockPeriod;
	configura_in <= '1';
        WAIT FOR clockPeriod;
        configura_in <= '0';

	wait for clockPeriod;
	configura_in <= '1';
        WAIT FOR clockPeriod;
        configura_in <= '0';

        WAIT UNTIL disponibiliza_out = '1';

        WAIT FOR 300 * clockPeriod;

        alimentado_in <= '1';

        WAIT FOR 20 * clockPeriod;

        alimentado_in <= '0';

        WAIT FOR 200 * clockPeriod;

        ---- final dos casos de teste da simulacao
        ASSERT false REPORT "Fim da simulacao" SEVERITY note;
        keep_simulating <= '0';

        WAIT; -- fim da simulação: aguarda indefinidamente
    END PROCESS;
END ARCHITECTURE;