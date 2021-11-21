
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


ENTITY circuito_uc IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
		  echo : IN STD_LOGIC;
		  disponivel : IN STD_LOGIC;
		  trigger : OUT STD_LOGIC; 
		  db_estado_uc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  db_estado_interface: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE circuito_uc_arch OF circuito_uc IS

	COMPONENT neko_uc
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
		  fim_stand : IN STD_LOGIC;
		  confirma : IN STD_LOGIC;
		  objeto : IN STD_LOGIC;
		  disponivel : IN STD_LOGIC;
        zera_stand : OUT STD_LOGIC;
		  zera_confirma : OUT STD_LOGIC;
		  conta_stand : OUT STD_LOGIC;
		  conta_confirma : OUT STD_LOGIC;
		  mede : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
	END COMPONENT;
	
	
	COMPONENT interface_hcsr04
	PORT (
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		echo : IN STD_LOGIC;
		medir : IN STD_LOGIC;
		pronto : OUT STD_LOGIC;
		trigger : OUT STD_LOGIC;
		medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
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
	 
	COMPONENT alerta_proximidade
	PORT (
		medida : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		medida_pronto : IN STD_LOGIC;
		proximo : OUT STD_LOGIC
	);
	END COMPONENT;

	SIGNAL s_fim_stand, s_confirma, s_objeto : STD_LOGIC;
	SIGNAL s_zera_stand, s_zera_confirma, s_pronto : STD_LOGIC;
	SIGNAL s_conta_stand, s_conta_confirma, s_mede, s_mede_disponivel : STD_LOGIC;
	SIGNAL s_medida : STD_LOGIC_VECTOR (11 DOWNTO 0);

	
	
BEGIN

	-- unidade de controle
	N_UC : neko_uc PORT MAP(
	  clock,
	  reset,
	  s_fim_stand,
	  s_confirma,
	  s_objeto,
	  disponivel,
	  s_zera_stand,
	  s_zera_confirma,
	  s_conta_stand,
	  s_conta_confirma,
	  s_mede,
	  db_estado_uc
	);

	-- sonar
	INTER : interface_hcsr04 PORT MAP(
		clock,
		reset,
		echo,
		s_mede,
		s_pronto,
		trigger,
		s_medida,
		db_estado_interface
	);
	
	-- alerta proximidade
	
	ALERT: alerta_proximidade PORT MAP(
		s_medida,
		s_pronto,
		s_objeto
	);
	
	-- contador confirma
	CONTADOR_CONFIRMA : contador_m GENERIC MAP(
        M => 2) PORT MAP (
        clock,
        reset,
        s_zera_confirma, -- s_reset_cont_final, 
        s_conta_confirma, 
        OPEN,
        OPEN, -- s_reset_cont,
        s_confirma
    );
	 
	 -- contador stand
	 CONTADOR_STAND : contador_m GENERIC MAP(
        M => 550000000) PORT MAP (
        clock,
        reset,
        s_zera_stand, -- s_reset_cont_final, 
        s_conta_stand,  
        OPEN,
        OPEN, -- s_reset_cont,
        s_fim_stand
    );
	
END ARCHITECTURE;