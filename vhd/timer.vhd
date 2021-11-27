
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY timer IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        configura : IN STD_LOGIC;
		alimentado : IN STD_LOGIC;
        periodo: IN STD_LOGIC_VECTOR (3 downto 0);
		i_dig5, i_dig4, i_dig3, i_dig2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        dig5, dig4, dig3, dig2, dig1, dig0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        db_dig5, db_dig4, db_dig3, db_dig2, db_dig1, db_dig0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        disponibiliza : OUT STD_LOGIC;
        salva : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_segundo: OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE timer_arch OF timer IS

    COMPONENT timer_uc
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        horario : IN STD_LOGIC;
		  alimentado : IN STD_LOGIC;
        configura: IN STD_LOGIC;
        atualiza: OUT STD_LOGIC;
        conta_alimentacao: OUT STD_LOGIC;
        salva: OUT STD_LOGIC;
        disponivel : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT timer_fd
	PORT (
		clock, reset, conta_alimentacao, configura, atualiza: IN STD_LOGIC;
        periodo: IN STD_LOGIC_VECTOR (3 downto 0);
		  i_dig5, i_dig4, i_dig3, i_dig2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        dig5, dig4, dig3, dig2, dig1, dig0 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		horario: OUT STD_LOGIC;
        db_segundo: OUT STD_LOGIC
	);
    END COMPONENT;

    COMPONENT hexa7seg
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end COMPONENT;

    SIGNAL s_conta_alimentacao, s_horario, s_atualiza, s_salva, s_disponivel, s_db_segundo : STD_LOGIC;
    SIGNAL s_fim_sinal, s_registra, s_limpa : STD_LOGIC;
    SIGNAL s_dig5, s_dig4, s_dig3, s_dig2, s_dig1, s_dig0, s_db_estado : STD_LOGIC_VECTOR (3 DOWNTO 0);

    SIGNAL s_dados_ascii : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    -- unidade de controle
    T_UC : timer_uc PORT MAP(
        clock,
        reset,
        s_horario,
		  alimentado,
        configura,
        s_atualiza,
        s_conta_alimentacao,
        s_salva,
        s_disponivel,
        s_db_estado
    );

    -- fluxo de dados
    T_FD : timer_fd PORT MAP(
        clock, 
        reset, 
        s_conta_alimentacao, 
        configura, 
        s_atualiza,
        periodo,
		  i_dig5, 
		  i_dig4, 
		  i_dig3, 
		  i_dig2, 
        s_dig5, 
        s_dig4, 
        s_dig3, 
        s_dig2, 
        s_dig1, 
        s_dig0,
		s_horario,
        s_db_segundo
    );

    HEX_DIG5: hexa7seg PORT MAP(
        s_dig5,
        db_dig5
    );

    HEX_DIG4: hexa7seg PORT MAP(
        s_dig4,
        db_dig4
    );

    HEX_DIG3: hexa7seg PORT MAP(
        s_dig3,
        db_dig3
    );

    HEX_DIG2: hexa7seg PORT MAP(
        s_dig2,
        db_dig2
    );

    HEX_DIG1: hexa7seg PORT MAP(
        s_dig1,
        db_dig1
    );

    HEX_DIG0: hexa7seg PORT MAP(
        s_dig0,
        db_dig0
    );

    HEX_ESTADO: hexa7seg PORT MAP(
        s_db_estado,
        db_estado
    );

    dig5 <= s_dig5;
    dig4 <= s_dig4;
    dig3 <= s_dig3;
    dig2 <= s_dig2;
    dig1 <= s_dig1;
    dig0 <= s_dig0;
    salva <= s_salva;
    disponibiliza <= s_disponivel;
    db_segundo <= s_db_segundo;

END ARCHITECTURE;