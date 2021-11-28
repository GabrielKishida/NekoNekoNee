
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY controle_display IS
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
END ENTITY;

ARCHITECTURE controle_display_arch OF controle_display IS

    COMPONENT hexa7seg IS
        PORT (
            hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux_4x6_7 IS
        PORT (
            D0_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D0_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D0_2 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D0_3 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D0_4 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D0_5 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

            D1_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D1_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D1_2 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D1_3 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D1_4 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D1_5 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

            D2_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D2_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D2_2 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D2_3 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D2_4 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D2_5 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

            D3_0 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D3_1 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D3_2 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D3_3 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D3_4 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            D3_5 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

            SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

            MUX0_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            MUX1_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            MUX2_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            MUX3_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            MUX4_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            MUX5_OUT : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)

        );
    END COMPONENT;

    SIGNAL SSEG_OFF : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";

    SIGNAL s_medida_2,
    s_medida_1,
    s_medida_0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL s_posicao_input : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_posicao : STD_LOGIC_VECTOR(6 DOWNTO 0);

    SIGNAL s_estado_serial_input,
    s_estado_despensa_input : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_estado_hcsr,
    s_estado_interface,
    s_estado_serial,
    s_estado_despensa : STD_LOGIC_VECTOR (6 DOWNTO 0);

BEGIN

    SSEG_MEDIDA2 : hexa7seg PORT MAP(
        hexa => dig_medida_2,
        sseg => s_medida_2
    );

    SSEG_MEDIDA1 : hexa7seg PORT MAP(
        hexa => dig_medida_1,
        sseg => s_medida_1
    );

    SSEG_MEDIDA0 : hexa7seg PORT MAP(
        hexa => dig_medida_0,
        sseg => s_medida_0
    );

    s_posicao_input <= '0' & db_posicao;
    SSEG_POSICAO : hexa7seg PORT MAP(
        hexa => s_posicao_input,
        sseg => s_posicao
    );

    SSEG_ESTADO_HCSR : hexa7seg PORT MAP(
        hexa => db_estado_hcsr,
        sseg => s_estado_hcsr
    );

    SSEG_ESTADO_INTERFACE : hexa7seg PORT MAP(
        hexa => db_estado_interface,
        sseg => s_estado_interface
    );

    s_estado_serial_input <= '0' & db_estado_serial;
    SSEG_ESTADO_SERIAL : hexa7seg PORT MAP(
        hexa => s_estado_serial_input,
        sseg => s_estado_serial
    );

    s_estado_despensa_input <= "00" & db_estado_despensa;
    SSEG_ESTADO_DESPENSA : hexa7seg PORT MAP(
        hexa => s_estado_despensa_input,
        sseg => s_estado_despensa
    );

    MUX_DISPLAY : mux_4x6_7 PORT MAP(
        D0_0 => dig_hora_1,
        D0_1 => dig_hora_0,
        D0_2 => dig_minuto_1,
        D0_3 => dig_minuto_0,
        D0_4 => dig_segundo_1,
        D0_5 => dig_segundo_0,

        D1_0 => s_medida_2,
        D1_1 => s_medida_1,
        D1_2 => s_medida_0,
        D1_3 => SSEG_OFF,
        D1_4 => SSEG_OFF,
        D1_5 => s_posicao,

        D2_0 => s_estado_hcsr,
        D2_1 => s_estado_interface,
        D2_2 => s_estado_serial,
        D2_3 => s_estado_despensa,
        D2_4 => db_estado_timer,
        D2_5 => SSEG_OFF,

        D3_0 => SSEG_OFF,
        D3_1 => SSEG_OFF,
        D3_2 => SSEG_OFF,
        D3_3 => SSEG_OFF,
        D3_4 => SSEG_OFF,
        D3_5 => SSEG_OFF,

        SEL => modo_display,

        MUX0_OUT => SSEG0,
        MUX1_OUT => SSEG1,
        MUX2_OUT => SSEG2,
        MUX3_OUT => SSEG3,
        MUX4_OUT => SSEG4,
        MUX5_OUT => SSEG5
    );
END ARCHITECTURE;