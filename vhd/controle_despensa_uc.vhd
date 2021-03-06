

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controle_despensa_uc IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        abre : IN STD_LOGIC;
        fecha : IN STD_LOGIC;
        zera : OUT STD_LOGIC;
        conta : OUT STD_LOGIC;
        enable_reg : OUT STD_LOGIC;
        posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        is_aberto : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE controle_despensa_uc_arch OF controle_despensa_uc IS

    TYPE tipo_estado IS (
        inicial,
        espera,
        prepara,
        aberto
    );

    SIGNAL Eatual : tipo_estado; -- estado atual
    SIGNAL Eprox : tipo_estado; -- proximo estado

    SIGNAL s_aberto : STD_LOGIC;

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
    PROCESS (abre, fecha, Eatual)
    BEGIN
        CASE Eatual IS

            WHEN inicial => Eprox <= espera;

            WHEN espera => IF (abre = '1') THEN
                Eprox <= prepara;
            ELSE
                Eprox <= espera;
        END IF;

        WHEN prepara => Eprox <= aberto;

        WHEN aberto => IF (fecha = '1') THEN

        Eprox <= espera;

        ELSE

        Eprox <= aberto;

    END IF;

    WHEN OTHERS => Eprox <= inicial;

END CASE;
END PROCESS;

-- logica de saida (Moore)
WITH Eatual SELECT
zera <= '1' WHEN prepara, '0' WHEN OTHERS;

WITH Eatual SELECT
enable_reg <= '1' WHEN prepara, '0' WHEN OTHERS;

WITH Eatual SELECT
s_aberto <= '1' WHEN aberto, '0' WHEN OTHERS;

WITH Eatual SELECT
posicao <= "111" WHEN aberto,
"000" WHEN OTHERS;

WITH Eatual SELECT
db_estado <= "00" WHEN inicial,
"01" WHEN espera,
"10" WHEN prepara,
"11" WHEN aberto,
"00" WHEN OTHERS;

conta <= s_aberto;
is_aberto <= s_aberto;

END controle_despensa_uc_arch;