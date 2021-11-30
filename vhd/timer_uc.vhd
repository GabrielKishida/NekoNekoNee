
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY timer_uc IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        horario : IN STD_LOGIC;
        alimentado : IN STD_LOGIC;
        configura : IN STD_LOGIC;
        atualiza : OUT STD_LOGIC;
        conta_alimentacao : OUT STD_LOGIC;
        salva : OUT STD_LOGIC;
        disponivel : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE timer_uc_arch OF timer_uc IS

    TYPE tipo_estado IS (
        inicial,
        aguarda_horario,
        disponibiliza,
        salva_horario
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
    PROCESS (alimentado, configura, horario, Eatual)
    BEGIN
        CASE Eatual IS

                --INICIAL
            WHEN inicial =>
                IF (configura = '1') THEN
                    Eprox <= aguarda_horario;
                ELSE
                    Eprox <= inicial;
                END IF;

                --AGUARDA HORARIO
            WHEN aguarda_horario =>
                IF (horario = '1') THEN
                    Eprox <= disponibiliza;
                ELSE
                    Eprox <= aguarda_horario;
                END IF;

                --DISPONIBILIZA
            WHEN disponibiliza =>
                IF (alimentado = '1') THEN
                    Eprox <= salva_horario;
                ELSE
                    Eprox <= disponibiliza;
                END IF;

                --SALVA HORARIO
            WHEN salva_horario => Eprox <= aguarda_horario;

        END CASE;
    END PROCESS;

    -- logica de saida (Moore)

    WITH Eatual SELECT
        disponivel <= '1' WHEN disponibiliza, '0' WHEN OTHERS;

    WITH Eatual SELECT
        conta_alimentacao <= '1' WHEN aguarda_horario, '0' WHEN OTHERS;

    WITH Eatual SELECT
        atualiza <= '1' WHEN salva_horario, '0' WHEN OTHERS;

    WITH Eatual SELECT
        salva <= '1' WHEN salva_horario, '0' WHEN OTHERS;

    -- Talvez tenha que ter um aguarda disponivel
    WITH Eatual SELECT
        db_estado <= "0000" WHEN inicial,
        "0001" WHEN aguarda_horario,
        "0010" WHEN disponibiliza,
        "0011" WHEN salva_horario,
        "0000" WHEN OTHERS;
END timer_uc_arch;