--Name: Ronald Mauricio Mercado Herrera 
--Date: September/30/2022
--Description: Project V3

connect sys/sys as sysdba;

SPOOL C:\BD2\MercadoRonaldPrj3.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual; 

--Question 1

connect scott/tiger;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE employee (p_empno IN NUMBER) AS
  v_ename emp.ename%TYPE;
  v_sal   emp.sal%TYPE;
  v_deptno  emp.deptno%TYPE;
  v_dname dept.dname%TYPE;
BEGIN
  SELECT ename, sal, deptno
  INTO   v_ename, v_sal, v_deptno
  FROM   emp
  WHERE  empno = p_empno;

  SELECT dname
  INTO v_dname
  FROM dept
  WHERE deptno = v_deptno;
  
  v_sal := v_sal * 12;

  DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno || ' is Mr./Mss. ' ||
        v_ename || ', who works in the  ' || v_dname || ' deparment ' || ', earning ' || v_sal || ' dollars per year !');

EXCEPTION

WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno ||
     ' does not exist !');
END;
/

EXEC employee (7782);
EXEC employee (1111);


--Question 2

connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE invent (p_inv_id IN NUMBER) AS
  v_itemId INVENTORY.ITEM_ID%TYPE;
  v_color INVENTORY.COLOR%TYPE;
  v_price   INVENTORY.INV_PRICE%TYPE;
  v_qoh  INVENTORY.INV_QOH%TYPE;
  v_itemDesc ITEM.ITEM_DESC%TYPE;

  v_value NUMBER;
  
  BEGIN
  SELECT COLOR, INV_PRICE, INV_QOH, ITEM_ID 
  INTO   v_color, v_price, v_qoh, v_itemId
  FROM   INVENTORY
  WHERE  INV_ID = p_inv_id;

  SELECT ITEM_DESC
  INTO v_itemDesc
  FROM ITEM
  WHERE ITEM_ID = v_itemId;

  v_value := v_qoh * v_price;

  DBMS_OUTPUT.PUT_LINE('Item Id ' || v_itemId ||', item description: '|| v_itemDesc ||
  ', price: ' || v_price || ', color: ' || v_color || ', inv qoh: ' || v_qoh || ', value: ' ||v_value);
  
  EXCEPTION

WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Inventory Id: ' || p_inv_id ||
     ' does not exist !');
END;
/

EXEC invent(3);
EXEC invent(1);
EXEC invent(99);

-- Question 3

connect des03/des03;
SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION find_age(p_birthday IN DATE)
 RETURN NUMBER AS
	v_age NUMBER;

BEGIN
	v_age := round (trunc((sysdate - p_birthday)/365));
RETURN v_age;
END;
/

-- Procedure

CREATE OR REPLACE PROCEDURE student_age(p_studentNumber IN NUMBER, p_name IN VARCHAR2, p_birthday IN DATE) AS

v_age NUMBER;

BEGIN

v_age := find_age(p_birthday);

DBMS_OUTPUT.PUT_LINE('Student Number: ' || p_studentNumber || ', Name: ' || p_name || ' ,Birthday:' || p_birthday
||', Age: ' || v_age);

END;
/

EXEC student_age(2,'juan jose','11/09/2018');
EXEC student_age(1,'luciana','13/03/2017');


-- QUESTION 4

connect des04/des04;
SET SERVEROUTPUT ON


CREATE OR REPLACE PROCEDURE update_table(p_cons_id IN NUMBER, p_skill_id IN NUMBER,
p_cert IN VARCHAR2(1)) AS

v_c_last consultant.c_last%TYPE;
v_c_first consultant.c_first%TYPE;
v_skill_desc skill.skill_description%TYPE;
v_skill_id skill.skill_id%TYPE;
v_cert consultant_skill.certification%TYPE;

BEGIN
	SELECT  c_last, c_first
	INTO v_c_last, v_c_first
	FROM consultant
	WHERE c_id = p_cons_id;

	SELECT skill_description
	INTO v_skill_desc
	FROM skill
	WHERE skill_id = p_skill_id;
	
	SELECT certification
	INTO v_cert
	FROM consultant_skill
	WHERE skill_id = p_skill_id;

	DBMS_OUTPUT.PUT_LINE('');

	END;
	/

	SPOOL OFF;


	--

	CREATE OR REPLACE PROCEDURE p_oct6_bonus AS
  -- step 1
  CURSOR customer_curr IS
    SELECT c_id, c_first, c_last, c_city
    FROM   customer;
  v_c_id customer.c_id%TYPE;
  v_c_first customer.c_first%TYPE;
  v_c_last   customer.c_last%TYPE;
  v_c_city   customer.c_city%TYPE;
BEGIN
  -- step 2
   OPEN customer_curr;
  -- step 3
   FETCH customer_curr INTO v_c_id, v_c_first, v_c_last, v_c_city ;
     WHILE customer_curr%FOUND  LOOP
       DBMS_OUTPUT.PUT_LINE('Row: ' || customer_curr%ROWCOUNT ||
  ' Customer ' || v_c_id ||
  ' is ' || v_c_first ||' ' ||v_c_last ||'. City is  ' || v_c_city);
     FETCH customer_curr INTO v_c_id, v_c_first, v_c_last, v_c_city ;
    END LOOP;
  -- step 4
  CLOSE customer_curr;
END;
/
exec p_oct6_bonus










	



	





