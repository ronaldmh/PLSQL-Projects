--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: October/7/2022
--Database II
--Description: Project V4

connect sys/sys as sysdba;

SPOOL C:\BD2\MercadoRonaldPrj4.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;


--Question 1 - First part

SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE L4Q1(p_num1 IN NUMBER, p_num2 IN NUMBER, p_out OUT VARCHAR2) AS

BEGIN	

	IF p_num1 = p_num2 THEN
		p_out := 'EQUAL';			
	ELSE
		p_out := 'DIFFERENT';		
	END IF;
	
    END;
     /

-- Using procedure - OPTIONAL
DECLARE
	v_out VARCHAR2(200);
BEGIN
	L4Q1(2,2,v_out);
DBMS_OUTPUT.PUT_LINE(v_out);
END;
/

-- Question1 - Second Part 

CREATE OR REPLACE PROCEDURE L8Q1(p_num1 IN NUMBER, p_num2 IN NUMBER) AS

v_area NUMBER;
V_perimeter NUMBER;
v_out VARCHAR2(200);

BEGIN
v_area := p_num1 * p_num2;
v_perimeter := (p_num1 + p_num2)*2;

L4Q1(p_num1, p_num2,v_out);

	IF v_out = 'EQUAL' THEN
		DBMS_OUTPUT.PUT_LINE('The area of a square ' || p_num1 || ' by ' || p_num2 || ' is '
		||v_area ||'. It`s perimeter is ' ||v_perimeter);	
	ELSE
		DBMS_OUTPUT.PUT_LINE('The area of a rectangle size ' ||  p_num1 || ' by ' || p_num2 || ' is '
		||v_area ||'. It`s perimeter is ' ||v_perimeter);	
	END IF;

END;
/

EXEC L8Q1(2,2);
EXEC L8Q1(5,2);


--Question 2 - Part 1

CREATE OR REPLACE PROCEDURE pseudofun(p_height IN NUMBER, p_width IN NUMBER, area_out OUT NUMBER, perimeter_out OUT NUMBER) AS

v_area NUMBER;
v_perimeter NUMBER;

BEGIN
v_area := p_height * p_width;
v_perimeter := (p_height + p_width)*2;

	 area_out := v_area;
	 perimeter_out := v_perimeter;
	 
END;
/

--Question 2 - Part 2 Call pseudofun

CREATE OR REPLACE PROCEDURE L4Q2(p_num1 IN NUMBER, p_num2 IN NUMBER)AS

v_area NUMBER;
v_perim NUMBER;

BEGIN

pseudofun(p_num1,p_num2,v_area,v_perim);

IF p_num1 = p_num2 THEN
		DBMS_OUTPUT.PUT_LINE('The area of a square ' || p_num1 || ' by ' || p_num2 || ' is '
		||v_area ||'. It`s perimeter is ' ||v_perim);	
	ELSE
		DBMS_OUTPUT.PUT_LINE('The area of a rectangle size ' ||  p_num1 || ' by ' || p_num2 || ' is '
		||v_area ||'. It`s perimeter is ' ||v_perim);	
	END IF;
END;
/


EXEC L4Q2(7,2);
EXEC L4Q2(10,2);
EXEC L4Q2(12,12);


-- OPTIONAL ----------------------------------------------------------------------------

-- Question 2 Option function with output 2 values

create  type area_perimeter is varray(2) of number;
 /

CREATE OR REPLACE FUNCTION pseudo_fun2(p_height IN NUMBER, p_width IN NUMBER)
RETURN area_perimeter AS

v_area NUMBER;
v_perimeter NUMBER;
v_return area_perimeter;

BEGIN

v_return := area_perimeter(0,0);
v_area := p_height * p_width;
v_perimeter := (p_height + p_width)*2;

	v_return(1):= v_area;
	v_return(2):= v_perimeter;
	
	RETURN v_return;

END;
/

-- Testin Function "pseudo_fun2"


SELECT pseudo_fun2(5,5) FROM DUAL;
SELECT pseudo_fun2(17,33) FROM DUAL;

------------------------------------------------------------------

--Question 3 - Part 1

--7clearwater
connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE updatePrice(p_inv_id IN NUMBER, p_perce IN NUMBER) AS

v_price inventory.inv_price%TYPE;
v_qoh  inventory.inv_qoh%TYPE;

BEGIN

  SELECT inv_price, inv_qoh
  INTO   v_price, v_qoh
  FROM   inventory
  WHERE  inv_id = p_inv_id;
  
  UPDATE inventory 
  SET inv_price = inv_price + ((p_perce/100)*inv_price)
  
  WHERE inv_id = p_inv_id;
  COMMIT;

END;
/



--Question 3 - Part 2

CREATE OR REPLACE PROCEDURE L4Q3(p_inv_id IN NUMBER, p_perce IN NUMBER) AS

v_price inventory.inv_price%TYPE;
v_qoh  inventory.inv_qoh%TYPE;
v_total NUMBER;

BEGIN

updatePrice(p_inv_id, p_perce);

	SELECT inv_price, inv_qoh
	INTO   v_price, v_qoh
	FROM   inventory
	WHERE  inv_id = p_inv_id;
	
	v_total := v_price * v_qoh;

DBMS_OUTPUT.PUT_LINE ('The new value of the inventory is ' || v_total);

EXCEPTION
     WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Inv_id '|| p_inv_id || ' does not exist ');
  
END;
/

Exec L4Q3(2,30);

Exec L4Q3(15,15);


-- END PROJECT 4

SPOOL OFF;

