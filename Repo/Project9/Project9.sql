--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: November/23/2022
--Database II
--Description: Project V9



SPOOL C:\BD2\MercadoRonaldPrj9.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

--Question 1 - 7clearwater

--Specification

CREATE OR REPLACE PACKAGE newCustomer_package IS

PROCEDURE newCus_insert(P_lastName VARCHAR2, P_Address VARCHAR2);
PROCEDURE newCus_insert(P_lastName VARCHAR2, P_birthdate DATE);
PROCEDURE newCus_insert(P_birthdate DATE, P_lastName VARCHAR2, P_Name VARCHAR2);
PROCEDURE newCus_insert(P_cust_id NUMBER, P_lastName VARCHAR2, P_birthdate DATE);

END;
/
-------------------------------------------------------------------------

CREATE SEQUENCE customer_sequence START WITH 7;

-------------------------------------------------------------------------Body

CREATE OR REPLACE PACKAGE BODY newCustomer_package IS

--Procedure 1
PROCEDURE newCus_insert(P_lastName VARCHAR2, P_Address VARCHAR2) AS
BEGIN
  INSERT INTO customer(c_id, c_last, c_address)
  VALUES(customer_sequence.NEXTVAL, P_lastName, P_Address);
  COMMIT;
END;

--Procedure 2
PROCEDURE newCus_insert(P_lastName VARCHAR2, P_birthdate DATE) AS
BEGIN
  INSERT INTO customer(c_id, c_last, c_birthdate)
  VALUES(customer_sequence.NEXTVAL, P_lastName, P_birthdate);
  COMMIT;
END;

--Procedure 3
  PROCEDURE newCus_insert(P_birthdate DATE, P_lastName VARCHAR2, P_Name VARCHAR2) AS
  BEGIN
      INSERT INTO customer(c_id, c_birthdate, c_last, c_first)
      VALUES(customer_sequence.NEXTVAL, P_birthdate, P_lastName, P_Name);
      COMMIT;
  END;

--Procedure 4
PROCEDURE newCus_insert(P_cust_id NUMBER, P_lastName VARCHAR2, P_birthdate DATE) AS

    CURSOR Cust_curr IS
    SELECT c_last, c_birthdate FROM customer
    WHERE c_id = P_cust_id;

    v_newCust_row Cust_curr%ROWTYPE;
          
  BEGIN
      OPEN Cust_curr;
      FETCH Cust_curr INTO v_newCust_row;

      IF Cust_curr%NOTFOUND THEN
        INSERT INTO customer(c_id, c_last, c_birthdate)
        VALUES(P_cust_id, P_lastName, P_birthdate);

      ELSE
        DBMS_OUTPUT.PUT_LINE('Customer number ' || P_cust_id ||' EXIST ');
      END IF;
      COMMIT;
  END;
END;
/

SET SERVEROUTPUT ON

exec newCustomer_package.newCus_insert('Osorio','5909 Toronto');
exec newCustomer_package.newCus_insert('Mercado','19/04/1991');
exec newCustomer_package.newCus_insert('19/04/1991','Mercado','Ronald');
exec newCustomer_package.newCus_insert(100,'Montoya','19/04/1991');
exec newCustomer_package.newCus_insert(100,'Herrera','19/04/1991');
exec newCustomer_package.newCus_insert(101,'Herrera','11/09/2018');

SPOOL OFF;



-------------------------------------------------------------------------------------------



SPOOL C:\BD2\MercadoRonaldPrj9_2.txt

--Question 2 - des03, 7northwoods

--Specification

CREATE OR REPLACE PACKAGE newStudent_package IS

  PROCEDURE newStud_insert(P_stud_id NUMBER, P_lastName VARCHAR2, P_birthdate DATE);
  PROCEDURE newStud_insert(P_lastName VARCHAR2, P_birthdate DATE);
  PROCEDURE newStud_insert(P_lastName VARCHAR2, P_Address VARCHAR2);
  PROCEDURE newStud_insert(P_lastName VARCHAR2, P_Name VARCHAR2, P_birthdate DATE, P_faculty_id NUMBER);

END;
/
-------------------------------------------------------------------------

CREATE SEQUENCE student_sequence START WITH 7;

-------------------------------------------------------------------------Body

CREATE OR REPLACE PACKAGE BODY newStudent_package IS

  --Procedure 1
  PROCEDURE newStud_insert(P_stud_id NUMBER, P_lastName VARCHAR2, P_birthdate DATE) AS
  
  v_name VARCHAR2(20);

  BEGIN
      
    SELECT s_last
    INTO v_name
    FROM student
    WHERE s_id = P_stud_id;

    DBMS_OUTPUT.PUT_LINE('ID STUDENT ALREADY EXIST');    
    
    EXCEPTION
    WHEN no_data_found THEN
        INSERT INTO student(s_id, s_last, s_dob)
        VALUES(P_stud_id, P_lastName, P_birthdate);
    DBMS_OUTPUT.PUT_LINE('NEW STUDENT HAS BEEN INSERTED');
 
 END;

 --------------------------------------------------------------------------

  --Procedure 2
  PROCEDURE newStud_insert(P_lastName VARCHAR2, P_birthdate DATE) AS

  BEGIN
    INSERT INTO student(s_id, s_last, s_dob)
    VALUES(student_sequence.NEXTVAL, P_lastName, P_birthdate);
    COMMIT;
  END;

--------------------------------------------------------------------------

  --Procedure 3
  PROCEDURE newStud_insert(P_lastName VARCHAR2, P_Address VARCHAR2) AS

  BEGIN
    INSERT INTO student(s_id, s_last, s_address)
    VALUES(student_sequence.NEXTVAL, P_lastName, P_Address);
    COMMIT;
  END;


--------------------------------------------------------------------------

  --Procedure 4
  PROCEDURE newStud_insert(P_lastName VARCHAR2, P_Name VARCHAR2, P_birthdate DATE, P_faculty_id NUMBER) AS

   v_f_id NUMBER;
  
  BEGIN

    SELECT f_id
    INTO  v_f_id   
    FROM faculty
    WHERE f_id = P_faculty_id;

    INSERT INTO student(s_id, s_last, s_first, s_dob, f_id)
    VALUES(student_sequence.NEXTVAL, P_lastName, P_Name, P_birthdate, P_faculty_id);
    COMMIT;
        
    EXCEPTION
    WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('Faculty id does not exist');

  END;


END;
/

--------------------------------------------------------------------------


--Test case procedure 1
EXEC newStudent_package.newStud_insert(101,'MONTOYA','19/04/1991');

--Test case procedure 2
EXEC newStudent_package.newStud_insert('MONTOYA','19/04/1991');

--Test case procedure 3
EXEC newStudent_package.newStud_insert('LINA','MONTOYA');

--Test case procedure 4

EXEC newStudent_package.newStud_insert('MONTOYA', 'Lina', '19/04/1991', 20);

EXEC newStudent_package.newStud_insert('MONTOYA', 'Lina', '19/04/1991', 1);



SPOOL OFF;