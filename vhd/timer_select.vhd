
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY timer_select IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        configura : IN STD_LOGIC;
        mais : IN STD_LOGIC;
        configurando : OUT STD_LOGIC;
        salva_config : OUT STD_LOGIC;
        dig5, dig4, dig3, dig2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        db_dig5, db_dig4, db_dig3, db_dig2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        db_estado : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE timer_select_arch OF timer_select IS

    COMPONENT timer_select_uc IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            configura : IN STD_LOGIC;
            contagem : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            dig5 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            enable_dig5 : OUT STD_LOGIC;
            enable_dig4 : OUT STD_LOGIC;
            enable_dig3 : OUT STD_LOGIC;
            enable_dig2 : OUT STD_LOGIC;
            salva_config : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
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

    COMPONENT registrador_4bits IS
        PORT (
            clock : IN STD_LOGIC;
            clear : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT edge_detector
        PORT (
            clk : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
            output : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT hexa7seg IS
        PORT (
            hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL s_contagem, s_dig5, s_dig4, s_dig3, s_dig2 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_db_estado : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_conta, s_configura : STD_LOGIC;
    SIGNAL s_enable_dig5, s_enable_dig4, s_enable_dig3, s_enable_dig2 : STD_LOGIC;

BEGIN

    UC : timer_select_uc PORT MAP(
        clock => clock,
        reset => reset,
        configura => s_configura,
        contagem => s_contagem,
        dig5 => s_dig5,
        enable_dig5 => s_enable_dig5,
        enable_dig4 => s_enable_dig4,
        enable_dig3 => s_enable_dig3,
        enable_dig2 => s_enable_dig2,
        salva_config => salva_config,
        db_estado => s_db_estado
    );

    MAIS_ED : edge_detector PORT MAP(
        clk => clock,
        signal_in => mais,
        output => s_conta
    );
    CONFIGURA_ED : edge_detector PORT MAP(
        clk => clock,
        signal_in => configura,
        output => s_configura
    );

    CONTADOR : contador_m GENERIC MAP(
        m => 10) PORT MAP(
        clock => clock,
        zera_as => reset,
        zera_s => reset,
        conta => s_conta,
        Q => s_contagem,
        fim => OPEN,
        meio => OPEN
    );

    REGDIG5 : registrador_4bits PORT MAP(
        clock => clock,
        clear => reset,
        enable => s_enable_dig5,
        D => s_contagem,
        Q => s_dig5
    );

    REGDIG4 : registrador_4bits PORT MAP(
        clock => clock,
        clear => reset,
        enable => s_enable_dig4,
        D => s_contagem,
        Q => s_dig4
    );

    REGDIG3 : registrador_4bits PORT MAP(
        clock => clock,
        clear => reset,
        enable => s_enable_dig3,
        D => s_contagem,
        Q => s_dig3
    );

    REGDIG2 : registrador_4bits PORT MAP(
        clock => clock,
        clear => reset,
        enable => s_enable_dig2,
        D => s_contagem,
        Q => s_dig2
    );

    SSEG_DIG5 : hexa7seg PORT MAP(
        hexa => s_dig5,
        sseg => db_dig5
    );

    SSEG_DIG4 : hexa7seg PORT MAP(
        hexa => s_dig4,
        sseg => db_dig4
    );

    SSEG_DIG3 : hexa7seg PORT MAP(
        hexa => s_dig3,
        sseg => db_dig3
    );

    SSEG_DIG2 : hexa7seg PORT MAP(
        hexa => s_dig2,
        sseg => db_dig2
    );

    SSEG_ESTADO : hexa7seg PORT MAP(
        hexa => s_db_estado,
        sseg => db_estado
    );

END ARCHITECTURE;