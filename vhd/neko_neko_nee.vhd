
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
ENTITY neko_neko_nee IS
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

	COMPONENT hexa7seg IS
		PORT (
			hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL s_medida : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL s_estado_uc, s_estado_interface : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL s_aberto, s_abre : STD_LOGIC;

BEGIN

	CTRL_DESPENSA : controle_despensa
	PORT MAP
	(
		clock => clock,
		reset => reset,
		abre => s_abre,
		tamanho_porcao => tamanho_porcao,
		pwm => pwm,
		aberto => s_aberto,
		db_pwm => db_pwm,
		db_posicao => db_posicao,
		db_tamanho_porcao => db_tamanho_porcao,
		db_estado => db_estado_despensa
	);

	CTRL_HCSRO4 : controle_hcsr04
	PORT MAP(
		clock => clock,
		reset => reset,
		echo => echo,
		disponivel => disponivel,
		aberto => s_aberto,
		trigger => trigger,
		indisponivel => indisponivel,
		abre => s_abre,
		medida => s_medida,
		db_estado_uc => s_estado_uc,
		db_estado_interface => s_estado_interface
	);

	SSEG_MEDIDA_0 : hexa7seg
	PORT MAP(
		hexa => s_medida(3 DOWNTO 0),
		sseg => db_medida_sseg0
	);

	SSEG_MEDIDA_1 : hexa7seg
	PORT MAP(
		hexa => s_medida(7 DOWNTO 4),
		sseg => db_medida_sseg1
	);

	SSEG_MEDIDA_2 : hexa7seg
	PORT MAP(
		hexa => s_medida(11 DOWNTO 8),
		sseg => db_medida_sseg2
	);

	SSEG_UC : hexa7seg
	PORT MAP(
		hexa => s_estado_uc,
		sseg => db_estado_uc_sseg
	);

	SSEG_INTERFACE : hexa7seg
	PORT MAP(
		hexa => s_estado_interface,
		sseg => db_estado_interface_sseg
	);

	db_aberto <= s_aberto;
	db_medida <= s_medida;
	db_estado_uc <= s_estado_uc;
	db_estado_interface <= s_estado_interface;

END ARCHITECTURE;