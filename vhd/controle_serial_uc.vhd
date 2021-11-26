LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controle_serial_uc IS
    PORT (
        clock, reset : IN STD_LOGIC;
        alimentou : IN STD_LOGIC;
        n_alimentou : IN STD_LOGIC;
        fim_tx : IN STD_LOGIC;
        fim_contagem : IN STD_LOGIC;
        zera : OUT STD_LOGIC;
        enviar_palavra : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        conta : OUT STD_LOGIC;
        ocorreu_alimentacao : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        db_estado : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE controle_serial_uc_arch OF controle_serial_uc IS

    TYPE tipo_estado IS (inicial, preparacao, transmite, fim_transmite, fim_total);

    SIGNAL Eatual : tipo_estado; -- estado atual
    SIGNAL Eprox : tipo_estado; -- proximo estado
    SIGNAL s_ocorreu_alimentacao : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

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
    PROCESS (Eatual, fim_tx, fim_contagem, alimentou, n_alimentou)
    BEGIN
        CASE Eatual IS
            WHEN inicial =>
                IF alimentou = '1' THEN
                    s_ocorreu_alimentacao <= "01000001"; -- Caractere A
                    Eprox <= preparacao;
                ELSIF n_alimentou = '1' THEN
                    s_ocorreu_alimentacao <= "01001110"; -- Caractere N
                    Eprox <= preparacao;
                ELSE
                    Eprox <= inicial;
                END IF;

            WHEN preparacao => Eprox <= transmite;

            WHEN transmite =>
                IF fim_tx = '1' AND fim_contagem = '0' THEN
                    Eprox <= fim_transmite;
                ELSIF fim_tx = '1' AND fim_contagem = '1' THEN
                    Eprox <= fim_total;
                ELSE
                    Eprox <= transmite;
                END IF;

            WHEN fim_transmite => Eprox <= transmite;

            WHEN fim_total =>
                IF alimentou = '1' THEN
                    s_ocorreu_alimentacao <= "01000001"; -- Caractere A
                    Eprox <= preparacao;
                ELSIF n_alimentou = '1' THEN
                    s_ocorreu_alimentacao <= "01001110"; -- Caractere N
                    Eprox <= preparacao;
                ELSE
                    Eprox <= fim_total;
                END IF;
        END CASE;

    END PROCESS;

    WITH Eatual SELECT
    zera <= '1' WHEN preparacao, '0' WHEN OTHERS;

    WITH Eatual SELECT
    conta <= '1' WHEN fim_transmite, '0' WHEN OTHERS;

    WITH Eatual SELECT
    pronto <= '1' WHEN fim_total, '0' WHEN OTHERS;

    WITH Eatual SELECT
    enviar_palavra <= '1' WHEN transmite, '0' WHEN OTHERS;

    WITH Eatual SELECT
    db_estado <= "001" WHEN inicial,
    "010" WHEN preparacao,
    "011" WHEN transmite,
    "100" WHEN fim_transmite,
    "101" WHEN fim_total,
    "000" WHEN OTHERS;

    ocorreu_alimentacao <= s_ocorreu_alimentacao;

END controle_serial_uc_arch;