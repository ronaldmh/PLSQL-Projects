--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: October/12/2022
--Database II
--Description: Project V5

connect sys/sys as sysdba;

SPOOL C:\BD2\MercadoRonaldPrj5.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

--Question 1 -- check

connect des03/des03;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE displayNorthWoods AS
  
  CURSOR term_curr IS
    SELECT term_id, term_desc, status
    FROM   term;
  v_id term.term_id%TYPE;
  v_desc term.term_desc%TYPE;
  v_status term.status%TYPE;
  
BEGIN
     OPEN term_curr;
	 
   FETCH term_curr INTO v_id, v_desc, v_status;
     WHILE term_curr%FOUND  LOOP
       DBMS_OUTPUT.PUT_LINE('Row: ' || term_curr%ROWCOUNT ||
  ' Id ' || v_id ||
  ' , description: ' || v_desc ||'Status: ' || v_status);
     FETCH term_curr INTO v_id, v_desc, v_status;
    END LOOP;
    CLOSE term_curr;
END;
/
exec displayNorthWoods;


--Question 2 -- check

connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE display_clearwater AS
  
  CURSOR inventory_curr IS
    SELECT inventory.inv_price, inventory.color, inventory.inv_qoh, item.item_desc
    FROM   inventory
	JOIN item ON item.item_id = inventory.item_id;

  v_inv_price inventory.inv_price%TYPE;
  v_color inventory.color%TYPE;
  v_inv_qoh   inventory.inv_qoh%TYPE;
  v_item_desc item.item_desc%TYPE;
  
BEGIN
  
   OPEN inventory_curr;
  
   FETCH inventory_curr INTO v_inv_price, v_color, v_inv_qoh, v_item_desc;
     WHILE inventory_curr%FOUND  LOOP
       DBMS_OUTPUT.PUT_LINE('Row: ' || inventory_curr%ROWCOUNT ||
  ' Price ' || v_inv_price ||
  ' , color is ' || v_color ||'. Quantity on hand is  ' || v_inv_qoh || ' Description: '||v_item_desc);
     
	 FETCH inventory_curr INTO v_inv_price, v_color, v_inv_qoh, v_item_desc;
    END LOOP;
  -- step 4
  CLOSE inventory_curr;
END;
/
exec display_clearwater


--Question 3 -- check

connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE update_clearwater(p_perce IN NUMBER) AS

  CURSOR inventory_curr IS
    SELECT inv_price, inv_id 	
    FROM inventory;

	v_inv_price inventory.inv_price%TYPE;
	v_inv_ID inventory.inv_id%TYPE;
  
BEGIN
   OPEN inventory_curr;
  
   FETCH inventory_curr INTO v_inv_price, v_inv_id;
     WHILE inventory_curr%FOUND  LOOP
	 	 
	  DBMS_OUTPUT.PUT_LINE('Row: ' || inventory_curr%ROWCOUNT ||
  '- Old Price: ' || v_inv_price || ' New price will be: '|| (v_inv_price + ((p_perce/100)*v_inv_price)) ||
  ', Now database is update.');
		
	UPDATE inventory
	 SET inv_price = inv_price + ((p_perce/100)*inv_price)
	 WHERE inv_id = v_inv_id; 
	 
	FETCH inventory_curr INTO v_inv_price, v_inv_id;
    END LOOP;
 COMMIT;
  CLOSE inventory_curr;
END;
/

exec update_clearwater(10);


--Question 4 -- check

connect scott/tiger;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE employees(p_numEmp IN NUMBER) AS
   
   v_counter NUMBER := 0 ;

  CURSOR employees_curr IS
    SELECT ename, sal
    FROM   emp
	ORDER BY sal DESC, ename ASC;
  
  v_ename emp.ename%TYPE;
  v_salary emp.sal%TYPE;
    
BEGIN
     OPEN employees_curr;
	 
   FETCH employees_curr INTO v_ename, v_salary;
     
	 WHILE employees_curr%FOUND  LOOP
       DBMS_OUTPUT.PUT_LINE('Row: ' || employees_curr%ROWCOUNT ||
  ' Name: ' || v_ename || ' , Salary: ' || v_salary);
     FETCH employees_curr INTO v_ename, v_salary;
	 
		v_counter := v_counter + 1;
	 
	 EXIT WHEN  v_counter > p_numEmp - 1;
    END LOOP;
    
	CLOSE employees_curr;
END;
/
EXEC employees(2);
EXEC employees(5);

--Question 5 -- check

connect scott/tiger;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE employeesAll(p_numEmp IN NUMBER) AS
   
   v_counter NUMBER := 0 ;

  CURSOR employees_curr IS
    SELECT ename, sal
    FROM   emp
	ORDER BY sal DESC;
  
  v_ename emp.ename%TYPE;
  v_salary emp.sal%TYPE;
    
BEGIN
     OPEN employees_curr;
	 
   FETCH employees_curr INTO v_ename, v_salary;
     
	 WHILE employees_curr%FOUND  LOOP
       DBMS_OUTPUT.PUT_LINE('Row: ' || employees_curr%ROWCOUNT ||
  ' Name: ' || v_ename || ' , Salary: ' || v_salary);
     FETCH employees_curr INTO v_ename, v_salary;
	 
		v_counter := v_counter + 1;
	 
	 EXIT WHEN  v_counter > p_numEmp - 1;
    END LOOP;
    
	CLOSE employees_curr;
END;
/
EXEC employeesAll(2);
EXEC employeesAll(5);

-- END PROJECT 5

SPOOL OFF;

