-
library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

--use IEEE.NUMERIC_STD.all;

entity buttonCount is -- initialize inputs and outputs
port (clock: in std_logic;
		key3: in std_logic;
		rst: in std_logic;
		count: out std_logic_vector(7 downto 0);
		en: out std_logic;
		rs: out std_logic;
		rw: out std_logic;
		lcd_on: out std_logic);
end buttonCount;


architecture rtl of buttonCount is

type state_t is (fs1, fs2, fs3, fs4, cld, ctd, em, sa1, sa2,
wd, wd1, wd2, wd3, wd4, wd5, wd6, wd7, wd8, wd9, wd10, wd11, 
wd12, wd13, wd14, wd15, wd16, wd17, wd18, wd19, wd20, wd21, 
wd22, wd23, wd24, rh); 
-- YOU	PUSHED	TOO
-- MANY	TIMES

signal state, next_state: state_t;
signal ckLong: std_logic;
signal next_lcdon, lcdon: std_logic;
signal number: integer range 0 to 9;
signal debounce: std_logic;

begin

-- creates longer clock
-- ensures that the screen is readable
clk_Long: process(clock)
	variable clk_Count : integer range 0 to 10000;
	variable ckLong_temp : std_logic;
	begin
		if (clock='1' and clock'event) then
		clk_Count := clk_Count + 1;
		if (clk_Count = 10000) then -- reset
			ckLong_temp := not ckLong_temp;
			clk_Count := 0;
		end if;
	end if;
	ckLong <= ckLong_temp;
end process clk_Long;

-- checks to see if state needs to be reset
-- cycles between the states
state_change: process(ckLong, rst)
	begin
		if rst = '0' then
			state <= fs1; -- resets states
			lcdon <= '0'; -- resets lcd
		elsif (ckLong'event and ckLong='1') then
			state <= next_state; -- cycles through states
			lcdon <= next_lcdon; -- ensures that LCD is on
		end if;	
end process state_change;

-- checks to see if number needs to be reset
-- upcounts the number if the button is pressed
counter: process(key3, rst)
begin
	if rst = '0' then -- check to reset count
		number <= 0;
	elsif (key3'event and key3='1') then -- if button is pressed
		if(number > 10) then
		-- do nothing
		else
			number <= number + 1;
		end if;
	end if;
end process counter;

-- state machine, cycles through all the options
-- prints messages
display: process(number, state, lcdon)
	begin
		next_state <= state;
		next_lcdon <= lcdon;
		case state is
		when fs1 => -- set function 1
			rs <= '0'; 
			rw <= '0';
			count <= "00111000";
			next_state <= fs2;
		when fs2 => -- set function 2
			rs <= '0'; 
			rw <= '0';
			count <= "00111000";
			next_state <= fs3;
		when fs3 => -- set function 3
			rs <= '0'; 
			rw <= '0';
			count <= "00111000";
			next_state <= fs4;
		when fs4 => -- set function 4
			rs <= '0'; 
			rw <= '0';
			count <= "00111000";
			next_state <= cld;
		when cld => -- display clear 
			rs <= '0'; 
			rw <= '0';
			count <= "00000001";
			next_state <= ctd;
		when ctd => -- display control
			rs <= '0'; 
			rw <= '0';
			count <= "00001100";
			next_state <= em;
		when em => -- entry mode
			rs <= '0'; 
			rw <= '0';
			count <= "00000110";
			next_state <= sa1;
			next_lcdon <= '1'; -- turn on the LCD
		when sa1 => -- set address second line
			rs <= '0'; 
			rw <= '0';
			count <= "11000000"; -- addr = 64
			next_state <= sa2;
		when sa2 => -- set address end of line
			rs <= '0';
			rw <= '0';
			count <= "11001111"; -- addr = 79 
			next_state <= wd;
		when wd => -- write data
			rs <= '1'; 
			rw <= '0';
			if(number > 9) then
				count <= "01011001"; -- Y
				next_state <= wd1; -- skips to writing the output
			else
				count <= "0011" & conv_std_logic_vector(number,4); -- writes the numeric characters
				next_state <= rh;
			end if;
		when wd1 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01001111"; -- O
			next_state <= wd2;
		when wd2 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01010101"; -- U
			next_state <= wd3;
		when wd3 =>
			rs <= '1'; 
			rw <= '0';
			count <= "10100000"; -- _
			next_state <= wd4;
		when wd4 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01010000"; -- P
			next_state <= wd5;
		when wd5 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01010101"; -- U
			next_state <= wd6;
		when wd6 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01010011"; -- S
			next_state <= wd7;
		when wd7 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01001000"; -- H
			next_state <= wd8;
		when wd8 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01000101"; -- E
			next_state <= wd9;
		when wd9 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01000100"; -- D
			next_state <= wd10;
		when wd10 =>
			rs <= '1'; 
			rw <= '0';
			count <= "10100000"; -- _
			next_state <= wd11;
		when wd11 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01010100"; -- T
			next_state <= wd12;
		when wd12 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01001111"; -- O
			next_state <= wd13;
		when wd13 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01001111"; -- O
			next_state <= wd14;
		when wd14 =>
			rs <= '0'; 
			rw <= '0';
			count <= "11000000"; -- \N
			next_state <= wd15;
		when wd15 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01001101"; -- M
			next_state <= wd16;
		when wd16 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01000001"; -- A
			next_state <= wd17;
		when wd17 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01001110"; -- N
			next_state <= wd18;
		when wd18 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01011001"; -- Y
			next_state <= wd19;
		when wd19 =>
			rs <= '1'; 
			rw <= '0';
			count <= "10100000"; -- _
			next_state <= wd20;
		when wd20=>
			rs <= '1'; 
			rw <= '0';
			count <= "01010100"; -- T
			next_state <= wd21;
		when wd21=>
			rs <= '1'; 
			rw <= '0';
			count <= "01001001"; -- I
			next_state <= wd22;
		when wd22 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01001101"; -- M
			next_state <= wd23;
		when wd23 =>
			rs <= '1'; 
			rw <= '0';
			count <= "01000101"; -- E
			next_state <= wd24;
		when wd24=>
			rs <= '1'; 
			rw <= '0';
			count <= "01010011"; -- S
			next_state <= rh;
		when rh => -- return home
			rs <= '0'; 
			rw <= '0';
			count <= "10000000";
			next_state <= wd;
		end case;
			
		
end process;
	
	lcd_on <= lcdon;
	en <= ckLong;	
end rtl;