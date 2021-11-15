LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controle_despensa IS
  PORT (
    clock : IN STD_LOGIC; -- 50MHz
    reset : IN STD_LOGIC;
    abre  : IN STD_LOGIC;
    tamanho_porcao : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --  00=0ms,  01=1ms  10=1.5ms  11=2ms
    pwm : OUT STD_LOGIC;
    db_pwm : OUT STD_LOGIC;
    db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    db_tamanho_porcao: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    db_estado : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
  );
END controle_despensa;

ARCHITECTURE rtl OF controle_despensa IS


COMPONENT edge_detector
    PORT ( clk         : in   std_logic;
           signal_in   : in   std_logic;
           output      : out  std_logic
    );
END COMPONENT;

COMPONENT controle_depensa_uc PORT (
    clock : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    abre  : IN STD_LOGIC;
    fecha : IN STD_LOGIC;
    zera : OUT STD_LOGIC;
    conta : OUT STD_LOGIC;
    enable_reg : OUT STD_LOGIC;
    posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    db_estado : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
END COMPONENT; 

COMPONENT controle_depensa_fd PORT (
    clock : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    enable_reg : IN STD_LOGIC;
    conta : IN STD_LOGIC;
    zera : IN STD_LOGIC;
    posicao : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    tamanho_porcao : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    fim : OUT STD_LOGIC;
    db_tamanho_porcao : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    pwm : OUT STD_LOGIC;
    db_pwm : OUT STD_LOGIC;
    db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END COMPONENT; 

signal s_fecha, s_output : std_logic;
signal s_db_estado : std_logic



BEGIN

  PROCESS (clock, reset, s_posicao)
  BEGIN

    -- detector de borda

    EDGE: edge_detector PORT MAP(
        clock,
        abre,
        s_output
    );

    -- unidade de controle
    CD_UC : controle_despensa_uc PORT MAP(
        clock,
        reset,
        s_output,
        s_fecha,
        zera,
        conta,
        enable_reg,
        posicao,
        s_db_estado
    );

    -- fluxo de dados
    CD_FD : controle_despensa_fd PORT MAP(
        clock,
        reset,
        enable_reg,
        conta,
        zera,
        posicao,
        tamanho_porcao,
        s_fecha,
        db_tamanho_porcao,
        pwm,
        db_pwm,
        db_posicao,
        OPEN
    );


END rtl;