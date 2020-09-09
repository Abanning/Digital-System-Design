LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DFF IS
PORT(
		D, CLK : IN std_logic;
		Q, Qn : OUT std_logic);
END DFF;

ARCHITECTURE behavioral OF DFF IS
BEGIN
	PROCESS(CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			Q <= D;
			Qn <= NOT D;
		END IF;
	END PROCESS;
END behavioral;

ENTITY NOT1 IS
PORT(
		in1 : IN std_logic;
		out1 : OUT std_logic);
END NOT1;

ARCHITECTURE behavioralNOT1 OF NOT1 IS
BEGIN
	PROCESS
	BEGIN
		out1 <= NOT in1;
	END PROCESS;
END behavioralNOT1;

ENTITY AND2 IS
PORT(
		in1, in2 : IN std_logic;
		out1 : OUT std_logic);
END AND2;

ARCHITECTURE behavioralAND2 OF AND2 IS
BEGIN
	PROCESS
	BEGIN
		out1 <= in1 AND in2;
	END PROCESS;
END behavioralAND2;

ENTITY OR2 IS
PORT(
		in1, in2 : IN std_logic;
		out1 : OUT std_logic);
END OR2;

ARCHITECTURE behavioralOR2 OF OR2 IS
BEGIN
	PROCESS
	BEGIN
		out1 <= in1 OR in2;
	END PROCESS;
END behavioralOR2;