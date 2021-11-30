
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY contador_alimentacao IS

    PORT (
        clock, zera_as, zera_s, conta : IN STD_LOGIC;
        teto: in std_logic_vector(3 downto 0);
        fim : OUT STD_LOGIC
    );
END ENTITY contador_alimentacao;

ARCHITECTURE comportamental OF contador_alimentacao IS
    SIGNAL teto_int : INTEGER;
    SIGNAL cont_max : INTEGER := teto_int*15;
    SIGNAL IQ : INTEGER;
BEGIN

    teto_int <= to_integer(unsigned(teto)) + 1;
    cont_max <= teto_int*10;

    PROCESS (clock, zera_as, zera_s, conta, IQ)
    BEGIN
        IF zera_as = '1' THEN
            IQ <= 0;
        ELSIF rising_edge(clock) THEN
            IF zera_s = '1' THEN
                IQ <= 0;
            ELSIF conta = '1' THEN
                IF IQ = cont_max - 1 THEN
                    IQ <= 0;
                ELSE
                    IQ <= IQ + 1;
                END IF;
            ELSE
                IQ <= IQ;
            END IF;
        END IF;

        -- fim de contagem    
        IF IQ = cont_max - 1 THEN
            fim <= '1';
        ELSE
            fim <= '0';
        END IF;


    END PROCESS;

END comportamental;