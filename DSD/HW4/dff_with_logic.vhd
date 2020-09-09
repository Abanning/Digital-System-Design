LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dff_with_logic IS
PORT(
		GATE : IN std_logic;
		DATA : IN std_logic;
		CLK  : IN std_logic;
		DATAOUT : OUT std_logic);
END dff_with_logic;

ARCHITECTURE rtl OF dff_with_logic IS
COMPONENT DFF IS
PORT(
		D, CLK : IN std_logic;
		Q, Qn : OUT std_logic);
END COMPONENT;

COMPONENT NOT1 IS
PORT(
		in1 : IN  std_logic;
		out1 : OUT std_logic);
END COMPONENT;

COMPONENT AND2 IS
PORT(
		in1, in2 : IN std_logic;
		out1 : OUT std_logic);
END COMPONENT;

COMPONENT OR2 IS
PORT(
		in1, in2 : IN std_logic;
		out1 : OUT std_logic);
END COMPONENT;

SIGNAL A, B, C, D : std_logic;
SIGNAL Q, Qn : std_logic;

BEGIN
	DFF1: DFF
	PORT MAP(
				D => D,
				CLK => CLK,
				Q => Q,
				Qn => Qn);

	N1: NOT1
	PORT MAP(
				in1 => GATE,
				out1 => A);
	
	A1: AND2
	PORT MAP(
				in1 => A,
				in2 => Q,
				out1 => B);
	
	A2: AND2
	PORT MAP(
				in1 => GATE,
				in2 => DATA,
				out1 => C);
	
	O1: OR2
	PORT MAP(
				in1 => B,
				in2 => C,
				out1 => D);

	PROCESS(CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			Q <= D;
			Qn <= NOT D;
		END IF;
	END PROCESS;
	
	DATAOUT <= Q;
END rtl;