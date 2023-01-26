--Name: Ronald Mauricio Mercado Herrera 
--Date: October/31/2022
--Description: Exam


--connection
CONNECT sys/sys as sysdba;

-- SPOOL file

SPOOL C:\BD2\MercadoRonaldPrj2.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual; 

CONNECT Ronald/1311;
SHOW USER;

SET SERVEROUTPUT ON


--QUESTION 1

CREATE OR REPLACE FUNCTION F_product (num1 IN NUMBER, num2 IN NUMBER)
     RETURN NUMBER AS
        
		v_result NUMBER;
     BEGIN
        v_result := num1 * num2 ;
      RETURN v_result;
     END;
     /

-- TEST QUESTION - 1

SELECT F_product (5,5) FROM DUAL;


--QUESTION 2
CREATE OR REPLACE PROCEDURE area_numbers (num1 IN NUMBER, num2 IN NUMBER) AS
v_area NUMBER;
BEGIN
v_area := F_product(num1,num2);

DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || num1 || ' by ' || num2 || ' ,the area is :' || v_area);

END;
/

-- TEST QUESTION - 2

EXEC area_numbers (3,7);

--QUESTION 3

CREATE OR REPLACE FUNCTION F_product (num1 IN NUMBER, num2 IN NUMBER)
     RETURN NUMBER AS
        
		v_result NUMBER;
     BEGIN
        v_result := num1 * num2 ;
		IF (num1 = num2) THEN
			DBMS_OUTPUT.PUT_LINE('Square');	
		END IF;	
      RETURN v_result;
     END;
     /
-- TEST QUESTION 3

SELECT F_product (7,7) FROM DUAL;

--QUESTION 4

CREATE OR REPLACE PROCEDURE currency_convertion (CAD IN NUMBER, COIN IN VARCHAR2) AS

amount NUMBER;
currency VARCHAR2(15);

BEGIN
IF COIN = 'E'  THEN
	amount := CAD * 1.5;
	currency := 'EURO';
ELSIF COIN = 'Y' THEN
	amount := CAD * 100;
	currency := 'YEN';
ELSIF COIN = 'V' THEN
	amount := CAD * 10000;
	currency := 'Viet Nam Dong';
ELSIF COIN = 'Z' THEN
	amount := CAD * 1000000;
	currency := 'ENDORA ZIP';
ELSE
	DBMS_OUTPUT.PUT_LINE('Enter a correct value');
END IF;
	DBMS_OUTPUT.PUT_LINE('For ' ||CAD || ' $' ||' canadian dollars, you will have '||amount||' $ ' ||currency);
END;
/

-- TEST QUESTION - 4

EXEC currency_convertion(2,'Y');

--QUESTION 5 - Function to find is a number is even or odd

CREATE OR REPLACE FUNCTION yes_EVEN (num_in IN NUMBER)
     RETURN BOOLEAN AS        
		
		v_bool BOOLEAN;
		v_number_in NUMBER;

     BEGIN
		v_number_in := MOD(num_in, 2);
		IF v_number_in = 0 THEN
			v_bool := TRUE;
		ELSE
			v_bool := FALSE;
		END IF;
      RETURN v_bool;
     END;
     /

--QUESTION 6 - Call the function 

CREATE OR REPLACE PROCEDURE call_func_yes_EVEN (num_in IN NUMBER) AS

v_result NUMBER;

BEGIN
	v_result := sys.diutil.bool_to_int (yes_EVEN(num_in));

	IF v_result = 1 THEN
		DBMS_OUTPUT.PUT_LINE('NUMBER '|| num_in ||' is EVEN');
	ELSE
		DBMS_OUTPUT.PUT_LINE('NUMBER '|| num_in ||' is ODD');
	END IF;	                         
END;
/

--TEST QUESTION 5 - 6

EXEC call_func_yes_EVEN (7);
EXEC call_func_yes_EVEN (12);


--BONUS QUESTION 6 - CONVERTER ANY DIRECTION

CREATE OR REPLACE PROCEDURE ConvertionMoney (amount IN NUMBER, COIN1 IN VARCHAR2, COIN2 IN VARCHAR2) AS

convertion NUMBER;

BEGIN

-- Convertion 1 From Euros 

IF COIN1 = 'E' THEN
	IF COIN2 = 'Y' THEN
		convertion := amount * 0.015;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount ||' Euros, you will have '|| convertion || ' YEN');
	
	ELSIF COIN2 = 'V' THEN
		convertion := amount * 0.00015;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' Euros, you will have '|| convertion || ' VIET NAM DONG');

	ELSIF COIN2 = 'Z' THEN
		convertion := amount * 0.0000015;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' Euros, you will have '|| convertion || ' ENDORA ZIP');

	ELSIF COIN2 = 'C' THEN
		convertion := amount * 1.5;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' Euros, you will have '|| convertion || 'CAD');

	END IF;

-- CONVERTION 2 - From YEN

ELSIF COIN1 = 'Y' THEN
	IF COIN2 = 'E' THEN
		convertion := amount /0.015;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount ||' YEN, you will have '|| convertion || ' EUROS');

	ELSIF COIN2 = 'V' THEN
		convertion := amount * 0.01;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' YEN, you will have '|| convertion || ' VIET NAM DONG');

	ELSIF COIN2 = 'Z' THEN
		convertion := amount * 0.0001;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' YEN, you will have '|| convertion || ' ENDORA ZIP');
	
	ELSIF COIN2 = 'C' THEN
		convertion := amount * 100;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' YEN, you will have '|| convertion || ' CAD');
	END IF;	

-- CONVERTION 3 From Viet Nam

ELSIF COIN1 = 'V' THEN
	IF COIN2 = 'E' THEN
		convertion := amount / 0.00015;
		DBMS_OUTPUT.PUT_LINE('For' ||amount||'  VIET NAM DONG, you will have '|| convertion || ' Euros');

	ELSIF COIN2 = 'Y' THEN
		convertion := amount / 0.01;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||'  VIET NAM DONG, you will have '|| convertion || ' YEN');

	ELSIF COIN2 = 'Z' THEN
		convertion := amount * 0.01;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||'  VIET NAM DONG, you will have '|| convertion || ' ENDORA ZIP');
	
	ELSIF COIN2 = 'C' THEN
		convertion := amount * 10000;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' VIET NAM DONG, you will have '|| convertion || ' CAD');
	END IF;

-- CONVERTION 4 From Endora ZIP

ELSIF COIN1 = 'Z' THEN
	IF COIN2 = 'E' THEN
		convertion := amount / 0.0000015;
		DBMS_OUTPUT.PUT_LINE('For' ||amount||'  ENDORA ZIP, you will have '|| convertion || ' Euros');

	ELSIF COIN2 = 'Y' THEN
		convertion := amount / 0.0001;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||'  ENDORA ZIP, you will have '|| convertion || ' YEN');

	ELSIF COIN2 = 'V' THEN
		convertion := amount / 0.01;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||'  ENDORA ZIP, you will have '|| convertion || ' VIET NAM DONG');
	
	ELSIF COIN2 = 'C' THEN
		convertion := amount * 1000000;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' ENDORA ZIP, you will have '|| convertion || ' CAD');
	
	END IF;

-- CONVERTION 5 From CAD

ELSIF COIN1 = 'C' THEN
	IF COIN2 = 'E' THEN
		convertion := amount / 1.5;
		DBMS_OUTPUT.PUT_LINE('For' ||amount||'  CAD, you will have '|| convertion || ' Euros');

	ELSIF COIN2 = 'Y' THEN
		convertion := amount / 100;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||'  CAD, you will have '|| convertion || ' YEN');

	ELSIF COIN2 = 'V' THEN
		convertion := amount / 10000;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||'  CAD, you will have '|| convertion || ' VIET NAM DONG');
	
	ELSIF COIN2 = 'Z' THEN
		convertion := amount / 1000000;
		DBMS_OUTPUT.PUT_LINE('For ' ||amount||' CAD, you will have '|| convertion || ' ENDORA ZIP');	
	END IF;
END IF;

END;
/

--TEST BONUS QUESTION 6

EXEC ConvertionMoney(500,'C','Z');

EXEC ConvertionMoney(200,'Z','Y');

EXEC ConvertionMoney(1.5,'V','Z');

EXEC ConvertionMoney(1500,'E','Y');

-- End Project 2

SPOOL OFF;
