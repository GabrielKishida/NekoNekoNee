--------------------------------------------------------------------
-- Arquivo   : contador_timer.vhd
-- Projeto   : Experiencia 4 - Interface com sensor de distancia
--------------------------------------------------------------------
-- Descricao : adaptacao do contador bcd com 4 digitos (modulo 10.000) 
--             descricao VHDL comportamental
--             1) reset sincrono
--             2) saida de fim de contagem para 24:00
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     19/09/2020  1.0     Edson Midorikawa  versao inicial
--     26/09/2020  1.1     Edson Midorikawa  revisao
--     19/09/2021  1.2     Edson Midorikawa  revisao
--     25/11/2021  1.3     Gustavo Azevedo   componente novo     
--------------------------------------------------------------------
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY contador_timer IS
    PORT (
        clock, zera, conta, registra : IN STD_LOGIC;
        i_dig5, i_dig4, i_dig3, i_dig2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        dig5, dig4, dig3, dig2, dig1, dig0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        fim : OUT STD_LOGIC
    );
END contador_timer;

ARCHITECTURE comportamental OF contador_timer IS

    SIGNAL s_dig5, s_dig4, s_dig3, s_dig2, s_dig1, s_dig0 : unsigned(3 DOWNTO 0);

BEGIN

    PROCESS (clock, conta, registra, zera)
    BEGIN
        IF (clock'event AND clock = '1') THEN
            IF (zera = '1') THEN -- reset sincrono
                s_dig0 <= "0000";
                s_dig1 <= "0000";
                s_dig2 <= "0000";
                s_dig3 <= "0000";
                s_dig4 <= "0000";
                s_dig5 <= "0000";
            ELSIF (registra = '1') THEN
                s_dig0 <= "0000";
                s_dig1 <= "0000";
                s_dig2 <= unsigned(i_dig2);
                s_dig3 <= unsigned(i_dig3);
                s_dig4 <= unsigned(i_dig4);
                s_dig5 <= unsigned(i_dig5);
            ELSIF (conta = '1') THEN
                IF (s_dig0="0000" AND s_dig1="0000" AND s_dig2="0000" AND s_dig3="0000" AND s_dig4="0100" AND s_dig5="0010") THEN
                    s_dig0 <= "0000";
                    s_dig1 <= "0000";
                    s_dig2 <= "0000";
                    s_dig3 <= "0000";
                    s_dig4 <= "0000";
                    s_dig5 <= "0000";
                END IF;
                IF (s_dig0 = "1001") THEN
                    s_dig0 <= "0000";
                    IF (s_dig1 = "0110") THEN
                        s_dig1 <= "0000";
                        IF (s_dig2 = "1001") THEN
                            s_dig2 <= "0000";
                            IF (s_dig3 = "0110") THEN
                                s_dig3 <= "0000";
                                IF (s_dig4 = "1001") THEN
                                    s_dig4 <= "0000";
                                    IF (s_dig5 = "0011") THEN
                                        s_dig5 <= "0000";
                                    ELSE
                                        s_dig5 <= s_dig5 + 1;
                                    END IF;
                                ELSE
                                    s_dig4 <= s_dig4 + 1;
                                END IF;
                            ELSE
                                s_dig3 <= s_dig3 + 1;
                            END IF;
                        ELSE
                            s_dig2 <= s_dig2 + 1;
                        END IF;
                    ELSE
                        s_dig1 <= s_dig1 + 1;
                    END IF;
                ELSE
                    s_dig0 <= s_dig0 + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- fim de contagem (comando VHDL when else)
    fim <= '1' WHEN s_dig0="0000" AND s_dig1="0000" AND s_dig2="0000" AND s_dig3="0000" AND s_dig4="0100" AND s_dig5="0010" ELSE
        '0';

    -- saidas
    dig5 <= STD_LOGIC_VECTOR(s_dig5);
    dig4 <= STD_LOGIC_VECTOR(s_dig4);
    dig3 <= STD_LOGIC_VECTOR(s_dig3);
    dig2 <= STD_LOGIC_VECTOR(s_dig2);
    dig1 <= STD_LOGIC_VECTOR(s_dig1);
    dig0 <= STD_LOGIC_VECTOR(s_dig0);

END comportamental;