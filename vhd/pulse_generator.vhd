library ieee;
use ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

entity pulse_generator is
    port ( clk         : in   std_logic;
           signal_in   : in   std_logic;
           output      : out  std_logic
    );
end pulse_generator;

architecture Behavioral of pulse_generator is

	component contador_m
        GENERIC (
            CONSTANT M : INTEGER
        );
        PORT (
            clock, zera_as, zera_s, conta : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
            fim, meio : OUT STD_LOGIC
        );
   END COMPONENT;
	
	SIGNAL signal_d : std_logic;
	SIGNAL s_reset : std_logic;

begin

	 CONTADOR_PULSO : contador_m GENERIC MAP(
        M => 100000000) PORT MAP (
        clk,
		  '0',
		  s_reset,
        signal_d,
        OPEN,
        s_reset,
        OPEN
    );


    process(clk, signal_in, s_reset)
    begin
        if signal_in= '1' and signal_in'event then
           signal_d <= '1';
        end if;
		  if s_reset = '1' then
		     signal_d <= '0';
		  end if;
    end process;
	 
	 output <= signal_d;


end Behavioral;
