

library IEEE;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

entity skid_buffer is
generic (
	DATA_WIDTH : integer := 8;
	)
port (
	i_clk , i_rst : in  std_logic;
	i_valid , i_ready : in std_logic;
	o_valid , o_ready : out std_logic;
	i_data : in std_logic_vector ( DATA_WIDTH - 1 downto 0 );
	o_data : out std_logic_vector ( DATA_WIDTH - 1 downto 0 )
);
end entity skid_buffer;


architecture rtl of skid_buffer is

signal r_data : std_logic_vector ( DATA_WIDTH - 1 downto 0 ):= ( others => '0');
signal r_valid : std_logic := '0';--its necessary to have this signal or we could just use a statemachine, bcs after there was a stall, the i_Valid may also fall smth may happen to transmitter so we must store and know the previous state of the transaction

begin

process ( clk , rst )	
begin
	if rising_edge ( clk ) then
		if i_ready = '1' and i_valid = '1' and r_valid = '0' then --we use r_Valid also as a flag to note if we are on stall or not
			o_data <= i_data;
			o_ready <= i_ready;
			o_valid <= i_valid;
			r_valid <= '0';
			r_data <= (others => '0');
		elseif i_ready = '0' and i_valid = '1' and r_valid = '0' then
			r_valid <= '1';
			r_data <= i_data;
			o_ready <= i_ready;
			o_valid <= i_valid;
			o_data <= i_data;
		elseif r_valid = '1' then
			o_data <= r_data;
			o_valid <= r_valid;
			o_ready <= i_ready
			r_Valid <= '1';
			if i_ready = '1' then
				r_valid <= '0';
			end if;
		end if;
	end if;
end process;

process ( clk , rst )
	if rising_Edge ( clk ) then
		if i_Ready = '0' and i_Valid = '1' and r_valid = '0' then	
				r_valid <= '1';
		else if i_ready = '1' and i_Valid = '1' and r_valid = '1' then
				r_valid <= '0';
		end if;
	end if;
end process;
				
====
if (!o_valid || i_ready)
    o_valid <= i_valid || r_valid
====



end architecture rtl;
