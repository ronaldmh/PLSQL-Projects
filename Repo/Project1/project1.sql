--Name: Ronald Mauricio Mercado Herrera 
--Date: September/9/2022
--Description: Project V1 

--connection
CONNECT sys/sys as sysdba

-- Log file
SPOOL C:\BD2\MercadoRonaldPrj1.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am')
FROM dual; 

CREATE USER Ronald IDENTIFIED BY 1311;
GRANT connect, resource TO Ronald;
CONNECT Ronald/1311;
SHOW USER;
SET SERVEROUTPUT ON

--QUESTION 1

CREATE OR REPLACE PROCEDURE triple_value (p_num_in IN NUMBER) AS

v_num_in NUMBER;
v_result NUMBER;

BEGIN
v_num_in := p_num_in;
v_result := v_num_in * 3;

DBMS_OUTPUT.PUT_LINE('The triple of ' || v_num_in || ' is ' || v_result);
END;
/

--Test procedure 1 - triple_value

EXEC triple_value (7);

--QUESTION 2

CREATE OR REPLACE PROCEDURE Celcius_to_Fahrenheit (p_num_in IN NUMBER) AS

v_num_in NUMBER;
v_result NUMBER;

BEGIN
v_num_in := p_num_in;
v_result := (9/5) * v_num_in + 32 ;

DBMS_OUTPUT.PUT_LINE(v_num_in || 'degree in C is equivalent to' || v_result || ' in F ');
END;
/

--Test procedure 2 - Celcius_to_Fahrenheit

EXEC Celcius_to_Fahrenheit (23);
EXEC Celcius_to_Fahrenheit (5);
EXEC Celcius_to_Fahrenheit (30);

--QUESTION 3

CREATE OR REPLACE PROCEDURE Fahrenheit_to_Celcius (p_num_in IN NUMBER) AS

v_num_in NUMBER;
v_result NUMBER;

BEGIN
v_num_in := p_num_in;
v_result := (5/9) * (v_num_in - 32) ;

DBMS_OUTPUT.PUT_LINE(v_num_in || 'degree in F is equivalent to' || v_result || ' in C ');
END;
/

--Test procedure 3 - Fahrenheit_to_Celcius

EXEC Fahrenheit_to_Celcius (71);
EXEC Fahrenheit_to_Celcius (41);
EXEC Fahrenheit_to_Celcius (86);

--QUESTION 4

CREATE OR REPLACE PROCEDURE tax_calculator (p_num_in IN NUMBER) AS
v_amount NUMBER;
v_gst NUMBER;
v_qst NUMBER;
v_subtotal NUMBER;
v_gtotal NUMBER;

BEGIN
v_amount := p_num_in;
v_gst := (v_amount * 5)/100 ;
v_qst := (v_amount * 9)/100 ;
v_subtotal := v_gst + v_qst;
v_gtotal := v_amount + v_subtotal;

DBMS_OUTPUT.PUT_LINE('For the price of $' || v_amount || ' You will have to pay $' || v_gst || ', $' || v_qst || 'QST for a total of $' || v_subtotal || 'The GRAND TOTAL is $' || v_gtotal);
END;
/

--Test procedure 4 - tax_calculator

EXEC tax_calculator (100);

--QUESTION 5

CREATE OR REPLACE PROCEDURE calculator_area_perimeter (p_num_in IN NUMBER,p_num2_in IN NUMBER) AS
v_width NUMBER;
v_height NUMBER;
v_area NUMBER;
v_perimeter NUMBER;

BEGIN
v_width := p_num_in;
v_height := p_num2_in;
v_area := v_width * v_height;
v_perimeter := (v_width + v_height) * 2;

DBMS_OUTPUT.PUT_LINE('The area of' || v_width || ' by' || v_height || ', is' || v_area || ' and the Perimeter is equal to ' || v_perimeter);
END;
/

--Test procedure 5 - calculator_area_perimeter

EXEC calculator_area_perimeter (2,3);

-- FUNCTIONS

--QUESTION 6

CREATE OR REPLACE FUNCTION F_Celcius_to_Fahrenheit (p_num_in IN NUMBER)
     RETURN NUMBER AS
        v_num_in NUMBER;
        v_result NUMBER;
     BEGIN
        v_num_in := p_num_in;
		v_result := (9/5) * v_num_in + 32 ;
      RETURN v_result;
     END;
     /

--Test Function 6 - Celcius_to_Fahrenheit

SELECT F_Celcius_to_Fahrenheit(32) FROM dual;
SELECT F_Celcius_to_Fahrenheit(18) FROM dual;
SELECT F_Celcius_to_Fahrenheit(10) FROM dual;

--QUESTION 7

CREATE OR REPLACE FUNCTION F_Fahrenheit_to_Celcius (p_num_in IN NUMBER)
     RETURN NUMBER AS
        v_num_in NUMBER;
        v_result NUMBER;
     BEGIN
        v_num_in := p_num_in;
		v_result := (5/9) * (v_num_in - 32) ; 
      RETURN v_result;
     END;
     /

--Test Function 7 - Fahrenheit_to_Celcius

SELECT F_Fahrenheit_to_Celcius(98) FROM dual;
SELECT F_Fahrenheit_to_Celcius(77) FROM dual;
SELECT F_Fahrenheit_to_Celcius(69) FROM dual;

-- End Project 1

SPOOL OFF;
