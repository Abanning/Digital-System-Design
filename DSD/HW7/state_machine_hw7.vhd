-- @filename: state_machine_hw7.vhd
-- @author: Alex Banning
-- @assignment: HW7 - Problem 2
-- @date: October 24th, 2019

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY state_machine_hw7 IS
PORT( 
      X : IN  std_logic_vector(1 DOWNTO 0);
      clk : IN  std_logic;
      Z : OUT std_logic_vector(1 downto 0));
END state_machine_hw7;

ARCHITECTURE rtl OF state_machine_hw7 IS
TYPE state_t IS (S0, S1, S2, S3);
SIGNAL state, next_state : state_t;
BEGIN
  the_machine: PROCESS(X, state)
  BEGIN

    -- defaults  
    next_state <= S0;
    Z	       <= '00';

    CASE state IS
      WHEN S0 =>
        IF (X = '00') THEN
          next_state <= S3;
		  Z <= '00'
        ELSIF (X = '01') THEN
          next_state <= S2;
          Z      <= '10';
		ELSIF (X = '01') THEN
          next_state <= S1;
          Z      <= '11';
		ELSe
          next_state <= S0;
          Z      <= '01';
        END IF;
	  WHEN S1 =>
        IF (X = '00') THEN
          next_state <= S0;
		  Z <= '10'
        ELSIF (X = '01') THEN
          next_state <= S1;
          Z      <= '10';
		ELSIF (X = '01') THEN
          next_state <= S2;
          Z      <= '11';
		ELSE
          next_state <= S3;
          Z      <= '11';
        END IF;	
	  WHEN S2 =>
        IF (X = '00') THEN
          next_state <= S3;
		  Z <= '00'
        ELSIF (X = '01') THEN
          next_state <= S0;
          Z      <= '10';
		ELSIF (X = '01') THEN
          next_state <= S1;
          Z      <= '11';
		ELSe
          next_state <= S1;
          Z      <= '01';
        END IF;
	  WHEN S3 =>
        IF (X = '00') THEN
          next_state <= S2;
		  Z <= '00'
        ELSIF (X = '01') THEN
          next_state <= S2;
          Z      <= '00';
		ELSIF (X = '01') THEN
          next_state <= S1;
          Z      <= '01';
		ELSe
          next_state <= S0;
          Z      <= '01';
        END IF;
     WHEN OTHERS =>
       -- do nothing
   END CASE; 
  END PROCESS the_machine;
    
  the_registers: PROCESS(clk, rst_n)
  BEGIN
    IF (clk='1' AND clk'event) THEN
      state <= next_state;
    END IF;
  END PROCESS the_registers;

END rtl;
