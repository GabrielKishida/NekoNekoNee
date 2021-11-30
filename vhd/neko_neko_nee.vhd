
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
ENTITY neko_neko_nee IS
	PORT (
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		echo : IN STD_LOGIC;
		configura : IN STD_LOGIC;
		mais : IN STD_LOGIC;
		tamanho_porcao : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		periodo : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		modo_display : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

		trigger : OUT STD_LOGIC;
		indisponivel : OUT STD_LOGIC;
		saida_serial : OUT STD_LOGIC;
		pwm : OUT STD_LOGIC;
		sseg0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		sseg1 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		sseg2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		sseg3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		sseg4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		sseg5 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		db_disponivel : OUT STD_LOGIC;
		db_pwm : OUT STD_LOGIC;
		db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		db_tamanho_porcao : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		db_medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		db_estado_uc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		db_aberto : OUT STD_LOGIC;
		db_estado_interface : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		db_estado_despensa : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE neko_neko_nee_arch OF neko_neko_nee IS

	COMPONENT controle_hcsr04 IS
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

	COMPONENT controle_despensa IS
		PORT (
			clock : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			abre : IN STD_LOGIC;
			tamanho_porcao : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			pwm : OUT STD_LOGIC;
			db_pwm : OUT STD_LOGIC;
			aberto : OUT STD_LOGIC;
			db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			db_tamanho_porcao : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			db_estado : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT pulse_generator IS
		PORT (
			clk : IN STD_LOGIC;
			signal_in : IN STD_LOGIC;
			output : OUT STD_LOGIC
		);
	END COMPONENT;

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

	COMPONENT controle_serial IS
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

	COMPONENT controle_display IS
		PORT (
			modo_display : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			-- Display Timer (00)
			dig_hora_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			dig_hora_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			dig_minuto_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			dig_minuto_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			dig_segundo_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			dig_segundo_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			-- Display Distance (01)
			dig_medida_2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			dig_medida_1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			dig_medida_0 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			db_posicao : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

			-- Display Debug (10)
			db_estado_hcsr : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			db_estado_interface : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			db_estado_serial : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			db_estado_despensa : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			db_estado_timer : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

			-- Display outputs
			SSEG0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			SSEG1 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			SSEG2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			SSEG3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			SSEG4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			SSEG5 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL s_dig_hora_1, s_dig_hora_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL s_dig_min_1, s_dig_min_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL s_dig_seg_1, s_dig_seg_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL s_db_dig5, s_db_dig4, s_db_dig3, s_db_dig2, s_db_dig1, s_db_dig0 : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL s_horas : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL s_minutos : STD_LOGIC_VECTOR (7 DOWNTO 0);

	SIGNAL s_medida : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL s_db_posicao : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL s_aberto, s_abre, s_reset, s_indisponivel, s_disponivel, s_salva, s_configurando : STD_LOGIC;

	SIGNAL s_estado_timer : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL s_estado_hcsr, s_estado_interface : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL s_estado_serial : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL s_estado_despensa : STD_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN
	s_horas <= s_dig_hora_1 & s_dig_hora_0;
	s_minutos <= s_dig_min_1 & s_dig_min_0;

	CTRL_SERIAL : controle_serial PORT MAP(
		clock => clock,
		reset => s_reset,
		horas => s_horas,
		minutos => s_minutos,
		alimentou => s_salva,
		n_alimentou => s_indisponivel,
		saida_serial => saida_serial,
		pronto => OPEN,
		db_saida_serial => OPEN,
		db_estado_uc => s_estado_serial,
		db_estado_tx => OPEN
	);

	TIMER_MODULE : timer PORT MAP(
		clock => clock,
		reset => reset,
		configura => configura,
		alimentado => s_abre,
		periodo => periodo,
		mais => mais,
		dig5 => s_dig_hora_1,
		dig4 => s_dig_hora_0,
		dig3 => s_dig_min_1,
		dig2 => s_dig_min_0,
		dig1 => s_dig_seg_1,
		dig0 => s_dig_seg_0,
		db_dig5 => s_db_dig5,
		db_dig4 => s_db_dig4,
		db_dig3 => s_db_dig3,
		db_dig2 => s_db_dig2,
		db_dig1 => s_db_dig1,
		db_dig0 => s_db_dig0,
		disponivel => s_disponivel,
		salva => s_salva,
		configurando => s_configurando,
		db_estado => s_estado_timer,
		db_segundo => OPEN
	);

	CTRL_DESPENSA : controle_despensa
	PORT MAP
	(
		clock => clock,
		reset => s_reset,
		abre => s_abre,
		tamanho_porcao => tamanho_porcao,
		pwm => pwm,
		aberto => s_aberto,
		db_pwm => db_pwm,
		db_posicao => s_db_posicao,
		db_tamanho_porcao => db_tamanho_porcao,
		db_estado => s_estado_despensa
	);

	CTRL_HCSRO4 : controle_hcsr04
	PORT MAP(
		clock => clock,
		reset => s_reset,
		echo => echo,
		disponivel => s_disponivel,
		aberto => s_aberto,
		trigger => trigger,
		indisponivel => s_indisponivel,
		abre => s_abre,
		medida => s_medida,
		db_estado_uc => s_estado_hcsr,
		db_estado_interface => s_estado_interface
	);

	CTRL_DISPLAY : controle_display PORT MAP(
		modo_display => modo_display,
		-- Display Timer (00)
		dig_hora_1 => s_db_dig5,
		dig_hora_0 => s_db_dig4,
		dig_minuto_1 => s_db_dig3,
		dig_minuto_0 => s_db_dig2,
		dig_segundo_1 => s_db_dig1,
		dig_segundo_0 => s_db_dig0,
		-- Display Distance (01)
		dig_medida_2 => s_medida(11 DOWNTO 8),
		dig_medida_1 => s_medida(7 DOWNTO 4),
		dig_medida_0 => s_medida (3 DOWNTO 0),
		db_posicao => s_db_posicao,

		-- Display Debug (10)
		db_estado_hcsr => s_estado_hcsr,
		db_estado_interface => s_estado_interface,
		db_estado_serial => s_estado_serial,
		db_estado_despensa => s_estado_despensa,
		db_estado_timer => s_estado_timer,

		-- Display outputs
		SSEG0 => sseg0,
		SSEG1 => sseg1,
		SSEG2 => sseg2,
		SSEG3 => sseg3,
		SSEG4 => sseg4,
		SSEG5 => sseg5
	);

	INDISPONIVEL_PULSE : pulse_generator
	PORT MAP(
		clk => clock,
		signal_in => s_indisponivel,
		output => indisponivel
	);

	db_disponivel <= s_disponivel;
	db_posicao <= s_db_posicao;
	db_aberto <= s_aberto;
	db_medida <= s_medida;
	db_estado_uc <= s_estado_hcsr;
	db_estado_interface <= s_estado_interface;
	db_estado_despensa <= s_estado_despensa;
	s_reset <= reset OR s_configurando;

END ARCHITECTURE;