library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity gpio_test is
	port( clk: 	 		in std_logic;
			reset: 		in std_logic;
			
			switches: 	in std_logic_vector(7 downto 0);
			leds: 		out std_logic_vector(7 downto 0);
			
			address: 	in std_logic;
			write:		in std_logic;
			writedata: 	in std_logic_vector(7 downto 0);
			read: 		in std_logic;
			readdata: 	out std_logic_vector(7 downto 0)
			);
end entity;

architecture rtl of gpio_test is

signal leds_out:		std_logic_vector(7 downto 0);

begin

	-- Output --
	output:
		process(clk, reset)
		begin
			if (reset = '1') then
				leds_out <= x"00";
			elsif (clk'event) and (clk = '1') and (write = '1') and (address = '0') then
				leds_out <= writedata;
			end if;
		end process;
		
	-- Input --
	readdata <= switches when read = '1' and address = '0' else
	(others => '0');
	
	leds <= leds_out;
	
end architecture;

