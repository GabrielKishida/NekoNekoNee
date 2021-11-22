
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY neko_uc IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
		  fim_stand : IN STD_LOGIC;
		  confirma : IN STD_LOGIC;
		  objeto : IN STD_LOGIC;
		  disponivel : IN STD_LOGIC;
		  pronto : IN STD_LOGIC;
		  fechado : IN STD_LOGIC;
        zera_stand : OUT STD_LOGIC;
		  zera_confirma : OUT STD_LOGIC;
		  conta_stand : OUT STD_LOGIC;
		  conta_confirma : OUT STD_LOGIC;
		  mede : OUT STD_LOGIC;
		  indisponivel : OUT STD_LOGIC;
		  abre : OUT STD_LOGIC;
		  db_fechado : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE neko_uc_arch OF neko_uc IS

    TYPE tipo_estado IS (
      inicial,
		standby,
		checa_objeto,
		aguarda_checagem,
		sem_objeto,
		tem_objeto,
		checa_disponivel,
		apresenta_indisponivel,
		abre_despensa,
		aguarda_fechar		
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
    PROCESS (fim_stand, confirma, objeto, disponivel, Eatual)
    BEGIN
        CASE Eatual IS
			
			--INICIAL
            WHEN inicial => Eprox <= standby;
			
			--STAND BY
			WHEN standby => IF (fim_stand = '1') THEN
				Eprox <= checa_objeto;
			ELSE 
				Eprox <= standby;
			END IF;
			
			--CHECA OBJETO
			WHEN checa_objeto => Eprox <= aguarda_checagem;
			
			--AGUARDA CHECAGEM
			WHEN aguarda_checagem => IF (objeto = '0' and pronto = '1') then
				Eprox <= sem_objeto;
			ELSIF (objeto = '1' and pronto = '1') then
				Eprox <= tem_objeto;
			ELSE
				Eprox <= aguarda_checagem;
			END IF;
			
			--SEM OBJETO
			WHEN sem_objeto => Eprox <= standby;
			
			--TEM OBJETO
			WHEN tem_objeto => IF (confirma = '0') THEN
				Eprox <= standby;
			ELSE
				Eprox <= checa_disponivel;
			END IF;
				
			--CHECA DISPONIVEL
			WHEN checa_disponivel => IF (disponivel = '1') THEN
				Eprox <= abre_despensa;
			ELSE
				Eprox <= apresenta_indisponivel;
			END IF;
				
			--ABRE DESPENSA
			WHEN abre_despensa => Eprox <= aguarda_fechar;
			
			--APRESENTA INDISPONIVEL
			WHEN apresenta_indisponivel => Eprox <= standby;
			
			--AGUARDA FECHAR
			WHEN aguarda_fechar => IF (fechado = '1') THEN
				Eprox <= standby;
			ELSE
				Eprox <= aguarda_fechar;
			END IF;
			

END CASE;
END PROCESS;

-- logica de saida (Moore)

WITH Eatual SELECT
    zera_stand <= '1' WHEN checa_objeto, '0' WHEN OTHERS;
	 
WITH Eatual SELECT
	 conta_stand <= '1' WHEN standby, '0' WHEN OTHERS;

WITH Eatual SELECT
    zera_confirma <= '1' WHEN sem_objeto | checa_disponivel, '0' WHEN OTHERS;

-- Conta confirma talvez tem q ser o tem_objeto ligado a um edge detector
-- para que o contagem atinja 2 antes da checagem contagem=2

WITH Eatual SELECT
    conta_confirma <= '1' WHEN tem_objeto, '0' WHEN OTHERS;
	 
WITH Eatual SELECT
    mede <= '1' WHEN checa_objeto, '0' WHEN OTHERS;
	 
WITH Eatual SELECT
    indisponivel <= '1' WHEN apresenta_indisponivel, '0' WHEN OTHERS;
	 
WITH Eatual SELECT
    abre <= '1' WHEN abre_despensa, '0' WHEN OTHERS;
	 

-- Talvez tenha que ter um aguarda disponivel
WITH Eatual SELECT
    db_estado <= "0000" WHEN inicial,
    "0001" WHEN standby,
    "0010" WHEN checa_objeto,
    "0011" WHEN aguarda_checagem,
	 "0100" WHEN sem_objeto,
	 "0101" WHEN tem_objeto,
	 "0110" WHEN checa_disponivel,
	 "0111" WHEN apresenta_indisponivel,
	 "1000" WHEN abre_despensa,
	 "1001" WHEN aguarda_fechar,
    "0000" WHEN OTHERS;
	 
db_fechado <= fechado;
	 

END neko_uc_arch;