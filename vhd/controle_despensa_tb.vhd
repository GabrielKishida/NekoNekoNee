LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controle_despensa_tb IS
END ENTITY;

ARCHITECTURE tb OF controle_despensa_tb IS

    COMPONENT controle_despensa IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            abre : IN STD_LOGIC;
            tamanho_porcao : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            pwm : OUT STD_LOGIC;
            db_pwm : OUT STD_LOGIC;
				db_aberto: OUT STD_LOGIC;
            db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            db_tamanho_porcao : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            db_estado : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clock_in : STD_LOGIC := '0';
    SIGNAL reset_in : STD_LOGIC := '0';
    SIGNAL abre_in : STD_LOGIC := '0';
    SIGNAL tamanho_porcao_in : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
    SIGNAL pwm_out : STD_LOGIC;
	 SIGNAL db_aberto_out : STD_LOGIC;
    SIGNAL db_pwm_out : STD_LOGIC;
    SIGNAL db_posicao_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL db_tamanho_porcao_out : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
    SIGNAL db_estado_out : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";

    SIGNAL keep_simulating : STD_LOGIC := '0';
    CONSTANT clockPeriod : TIME := 20 ns;

BEGIN

    clock_in <= (NOT clock_in) AND keep_simulating AFTER clockPeriod/2;

    dut : controle_despensa PORT MAP(
        clock => clock_in,
        reset => reset_in,
        abre => abre_in,
        tamanho_porcao => tamanho_porcao_in,
        pwm => pwm_out,
        db_pwm => db_pwm_out,
		  db_aberto => db_aberto_out,
        db_posicao => db_posicao_out,
        db_tamanho_porcao => db_tamanho_porcao_out,
        db_estado => db_estado_out
    );

    stimulus : PROCESS IS
    BEGIN

        ASSERT false REPORT "Inicio da simulacao" & LF & "... Simulacao ate 800 ms. Aguarde o final da simulacao..." SEVERITY note;
        keep_simulating <= '1';

        ---- inicio: reset ----------------
        reset_in <= '1';
        WAIT FOR 2 * clockPeriod;
        reset_in <= '0';
        WAIT FOR 10 * clockPeriod;

        tamanho_porcao_in <= "00";
        WAIT FOR 100 ms;

        abre_in <= '1';
        WAIT FOR 5 * clockPeriod;

        abre_in <= '0';
        WAIT FOR 101 ms;

        tamanho_porcao_in <= "01";
        WAIT FOR 100 ms;

        abre_in <= '1';
        WAIT FOR 5 * clockPeriod;

        abre_in <= '0';
        WAIT FOR 151 ms;

        tamanho_porcao_in <= "10";
        WAIT FOR 100 ms;

        abre_in <= '1';
        WAIT FOR 5 * clockPeriod;

        abre_in <= '0';
        WAIT FOR 201 ms;

        tamanho_porcao_in <= "11";
        WAIT FOR 100 ms;

        abre_in <= '1';
        WAIT FOR 5 * clockPeriod;

        abre_in <= '0';
        WAIT FOR 301 ms;

        ASSERT false REPORT "Fim da simulacao" SEVERITY note;
        keep_simulating <= '0';

        WAIT;
    END PROCESS;
END ARCHITECTURE;