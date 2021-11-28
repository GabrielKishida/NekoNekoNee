
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY timer_select_uc IS
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
        configurando : OUT STD_LOGIC;
        salva_config : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE timer_select_uc_arch OF timer_select_uc IS

    TYPE tipo_estado IS (
        inicial,
        set_dig5,
        set_dig4,
        set_dig3,
        set_dig2,
        config_horario,
        fim
    );

    SIGNAL Eatual : tipo_estado; -- estado atual
    SIGNAL Eprox : tipo_estado; -- proximo estado

BEGIN

    -- memoria de estado
    PROCESS (reset, clock)
    BEGIN
        IF reset = '1' THEN
            Eatual <= inicial;
        ELSIF clock'event AND clock = '1' THEN
            Eatual <= Eprox;
        END IF;
    END PROCESS;

    -- logica de proximo estado
    PROCESS (configura, contagem, dig5, Eatual)
    BEGIN
        CASE Eatual IS

                --INICIAL
            WHEN inicial => Eprox <= set_dig5;

            WHEN set_dig5 =>
                IF (configura = '1' AND unsigned(contagem) < 3) THEN
                    Eprox <= set_dig4;
                ELSE
                    Eprox <= set_dig5;
                END IF;

            WHEN set_dig4 =>
                IF (
                    configura = '1' AND
                    (
                    (
                    unsigned(dig5) = 2 AND unsigned(contagem) < 5
                    )
                    OR (
                    unsigned(dig5) < 2
                    )
                    )
                    ) THEN
                    Eprox <= set_dig3;
                ELSE
                    Eprox <= set_dig4;
                END IF;

            WHEN set_dig3 =>
                IF (configura = '1' AND unsigned(contagem) < 7) THEN
                    Eprox <= set_dig2;
                ELSE
                    Eprox <= set_dig3;
                END IF;

            WHEN set_dig2 =>
                IF (configura = '1') THEN
                    Eprox <= config_horario;
                ELSE
                    Eprox <= set_dig2;
                END IF;

            WHEN config_horario => Eprox <= fim;

            WHEN fim => Eprox <= fim;

        END CASE;
    END PROCESS;

    -- logica de saida (Moore)

    WITH Eatual SELECT
        enable_dig5 <= '1' WHEN set_dig5, '0' WHEN OTHERS;

    WITH Eatual SELECT
        enable_dig4 <= '1' WHEN set_dig4, '0' WHEN OTHERS;

    WITH Eatual SELECT
        enable_dig3 <= '1' WHEN set_dig3, '0' WHEN OTHERS;

    WITH Eatual SELECT
        enable_dig2 <= '1' WHEN set_dig2, '0' WHEN OTHERS;

    WITH Eatual SELECT
        salva_config <= '1' WHEN config_horario, '0' WHEN OTHERS;

    WITH Eatual SELECT
        configurando <= '0' WHEN fim, '1' WHEN OTHERS;

    -- Talvez tenha que ter um aguarda disponivel
    WITH Eatual SELECT db_estado <=
        "0000" WHEN inicial,
        "0001" WHEN set_dig5,
        "0010" WHEN set_dig4,
        "0011" WHEN set_dig3,
        "0100" WHEN set_dig2,
        "0101" WHEN config_horario,
        "0110" WHEN fim,
        "1111" WHEN OTHERS;
END timer_select_uc_arch;