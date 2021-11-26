
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY controle_serial IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        horas : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        minutos : IN STD_LOGIC (7 DOWNTO 0);
        alimentou : IN STD_LOGIC;
        n_alimentou : IN STD_LOGIC;
        db_estado_uc : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        db_estado_tx : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE controle_serial_arch OF controle_serial IS

    COMPONENT controle_serial_uc
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            fim_stand : IN STD_LOGIC;
            confirma : IN STD_LOGIC;
            objeto : IN STD_LOGIC;
            disponivel : IN STD_LOGIC;
            pronto : IN STD_LOGIC;
            aberto : IN STD_LOGIC;
            zera_stand : OUT STD_LOGIC;
            zera_confirma : OUT STD_LOGIC;
            conta_stand : OUT STD_LOGIC;
            conta_confirma : OUT STD_LOGIC;
            mede : OUT STD_LOGIC;
            indisponivel : OUT STD_LOGIC;
            abre : OUT STD_LOGIC;
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

    COMPONENT mux_8x1_8 IS
        PORT (
            D0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D5 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D6 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            D7 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            SEL : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            MUX_OUT : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL s_ocorreu_alimentacao : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL asc_hora1, asc_hora0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL asc_minuto1, asc_minuto0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL s_a_transmitir : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
BEGIN

    asc_hora1 <= "0011" & horas(7 DOWNTO 4);
    asc_hora0 <= "0011" & horas(3 DOWNTO 0);
    asc_minuto1 <= "0011" & minutos(7 DOWNTO 4);
    asc_minuto0 <= "0011" & minutos(3 DOWNTO 0);

    MUX_SERIAL : mux_8x1_8 PORT MAP(
        D0 => s_ocorreu_alimentacao,
        D1 => asc_hora1,
        D2 => asc_hora0,
        D3 => "00111010",
        D4 => asc_minuto1,
        D5 => asc_minuto0,
        D6 => "00101110",
        D7 => "00000000",
        SEL => s_sel,
        MUX_OUT => s_a_transmitir
    );

END ARCHITECTURE;