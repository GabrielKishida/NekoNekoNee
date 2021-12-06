
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY controle_hcsr04 IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        echo : IN STD_LOGIC;
        disponivel : IN STD_LOGIC;
        aberto : IN STD_LOGIC;
        override : IN STD_LOGIC;
        trigger : OUT STD_LOGIC;
        indisponivel : OUT STD_LOGIC;
        abre : OUT STD_LOGIC;
        medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        db_estado_uc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        db_estado_interface : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE controle_hcsr04_arch OF controle_hcsr04 IS

    COMPONENT controle_hcsr04_uc
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            fim_stand : IN STD_LOGIC;
            confirma : IN STD_LOGIC;
            objeto : IN STD_LOGIC;
            disponivel : IN STD_LOGIC;
            pronto : IN STD_LOGIC;
            aberto : IN STD_LOGIC;
            override : IN STD_LOGIC;
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

    COMPONENT interface_hcsr04
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            echo : IN STD_LOGIC;
            medir : IN STD_LOGIC;
            pronto : OUT STD_LOGIC;
            trigger : OUT STD_LOGIC;
            medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
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

    COMPONENT alerta_proximidade
        PORT (
            medida : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            medida_pronto : IN STD_LOGIC;
            proximo : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT edge_detector
        PORT (
            clk : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
            output : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL s_fim_stand, s_confirma, s_objeto, s_indisponivel, s_override : STD_LOGIC;
    SIGNAL s_zera_stand, s_zera_confirma, s_pronto : STD_LOGIC;
    SIGNAL s_conta_stand, s_conta_confirma, s_mede, s_mede_disponivel : STD_LOGIC;
    SIGNAL s_medida : STD_LOGIC_VECTOR (11 DOWNTO 0);

BEGIN

    -- unidade de controle
    N_UC : controle_hcsr04_uc PORT MAP(
        clock,
        reset,
        s_fim_stand,
        s_confirma,
        s_objeto,
        disponivel,
        s_pronto,
        aberto,
        s_override,
        s_zera_stand,
        s_zera_confirma,
        s_conta_stand,
        s_conta_confirma,
        s_mede,
        s_indisponivel,
        abre,
        db_estado_uc
    );

    -- sonar
    INTER : interface_hcsr04 PORT MAP(
        clock,
        reset,
        echo,
        s_mede,
        s_pronto,
        trigger,
        s_medida,
        db_estado_interface
    );

    -- edge detector para o override

    ED : edge_detector PORT MAP(
        clock,
        override,
        s_override
    );

    -- alerta proximidade

    ALERT : alerta_proximidade PORT MAP(
        s_medida,
        s_pronto,
        s_objeto
    );

    -- contador confirma
    CONTADOR_CONFIRMA : contador_m GENERIC MAP(
        M => 2) PORT MAP (
        clock,
        reset,
        s_zera_confirma, -- s_reset_cont_final, 
        s_conta_confirma,
        OPEN,
        s_confirma,
        OPEN
    );

    -- contador stand
    CONTADOR_STAND : contador_m GENERIC MAP(
        M => 500000000) PORT MAP (
        clock,
        reset,
        s_zera_stand, -- s_reset_cont_final, 
        s_conta_stand,
        OPEN,
        s_fim_stand,
        OPEN
    );

    medida <= s_medida;
    indisponivel <= s_indisponivel;

END ARCHITECTURE;