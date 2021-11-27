LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY divisor_timer IS

    PORT (
        clock, zera_as, zera_s, conta : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(100)))) - 1 DOWNTO 0);
        fim, meio : OUT STD_LOGIC
    );
END ENTITY divisor_timer;

ARCHITECTURE comportamental OF divisor_timer IS
    CONSTANT SEGUNDO : INTEGER := 100;
    SIGNAL IQ : INTEGER RANGE 0 TO SEGUNDO - 1;
BEGIN

    PROCESS (clock, zera_as, zera_s, conta, IQ)
    BEGIN
        IF zera_as = '1' THEN
            IQ <= 0;
        ELSIF rising_edge(clock) THEN
            IF zera_s = '1' THEN
                IQ <= 0;
            ELSIF conta = '1' THEN
                IF IQ = SEGUNDO - 1 THEN
                    IQ <= 0;
                ELSE
                    IQ <= IQ + 1;
                END IF;
            ELSE
                IQ <= IQ;
            END IF;
        END IF;

        -- fim de contagem    
        IF IQ = SEGUNDO - 1 THEN
            fim <= '1';
        ELSE
            fim <= '0';
        END IF;

        -- meio da contagem
        IF IQ = SEGUNDO/2 - 1 THEN
            meio <= '1';
        ELSE
            meio <= '0';
        END IF;

        Q <= STD_LOGIC_VECTOR(to_unsigned(IQ, Q'length));

    END PROCESS;

END comportamental;