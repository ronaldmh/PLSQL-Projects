--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: December/3/2022
--Database II
--Description: Project 10

SPOOL C:\BD2\MercadoRonald_Project10.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON;

-- Question 1

/*We need to know WHO, and WHEN the table CUSTOMER is modified.
Create table, sequence, and trigger to record the needed information.
*/

connect sys/sys as sysdba;
DROP USER ROM CASCADE;
create user rom identified by 123;

connect des02/des02;

GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO rom;



CREATE SEQUENCE customer_audit_seq;

/*Creation table*/
CREATE TABLE CUSTOMER_ROW_AUDIT(row_number_id NUMBER, date_updated DATE,
 updating_user VARCHAR2(20));

/*Trigger section*/
CREATE OR REPLACE TRIGGER customer_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON customer

  BEGIN
    INSERT INTO CUSTOMER_ROW_AUDIT 
    VALUES(customer_audit_seq.NEXTVAL, sysdate, user);
  END;
/

connect sys/sys as sysdba;
GRANT CREATE SESSION TO rom;

/*Connect second user and do modification of table*/
CONNECT rom/123;

select c_password from des02.customer where c_id=6;

-- Update columns
UPDATE des02.customer SET c_password = 'change_password'
WHERE c_id = 6 ;
commit;


-- Check changes did it
connect des02/des02;

SELECT row_number_id, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI:SS Am'), 
updating_user FROM  CUSTOMER_ROW_AUDIT;

SPOOL OFF;


-------------------------------------------------------------------------------------------------


-- Question 2

/*Table ORDER_LINE is subject to INSERT, UPDATE, and DELETE, create a trigger to record who, when, and the action performed on the table order_line in a table called order_line_audit.
(hint: use UPDATING, INSERTING, DELETING to verify for action performed. For example: IF UPDATING THEN …)
*/

SPOOL C:\BD2\MercadoRonald_Project10_2.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON;


connect des02/des02;


CREATE SEQUENCE orderL_audit_seq;

/*Creation table*/
CREATE TABLE ORDER_LINE_AUDIT(row_number_id NUMBER, date_updated DATE,
 updating_user VARCHAR2(20), action_performed VARCHAR2(30));

/*Trigger section*/
CREATE OR REPLACE TRIGGER order_line_audit
AFTER INSERT OR UPDATE OR DELETE ON customer
  BEGIN
    IF INSERTING THEN
    INSERT INTO ORDER_LINE_AUDIT 
    VALUES(orderL_audit_seq.NEXTVAL, sysdate, user,'INSERT');
  ELSIF UPDATING THEN 
    INSERT INTO ORDER_LINE_AUDIT
    VALUES(orderL_audit_seq.NEXTVAL, sysdate, user,'UPDATE');
  ELSIF DELETING THEN 
    INSERT INTO ORDER_LINE_AUDIT
    VALUES(orderL_audit_seq.NEXTVAL, sysdate, user,'DELETE');
  END IF; 
  END;
/

connect des02/des02;

GRANT SELECT, INSERT, UPDATE, DELETE ON order_line TO rom;

/*Connect second user and do modification of table*/
CONNECT rom/123;

select ol_quantity from des02.order_line
WHERE o_id = 1 AND inv_id = 14;

-- Update columns
UPDATE des02.order_line SET ol_quantity = 5
WHERE o_id = 1 AND inv_id = 14;
commit;

-- Insert columns
INSERT INTO des02.order_line
VALUES(25,1,10);
commit;

-- Delete columns
DELETE FROM des02.order_line
WHERE o_id = 3 AND inv_id = 26;
commit;


-- Check changes did it
connect des02/des02;

SELECT row_number_id, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI:SS Am'), 
updating_user FROM  ORDER_LINE_AUDIT;

SPOOL OFF;

-------------------------------------------------------------------------------------------------------------

-- Question 3

/*
Create a table called order_line_row_audit to record who, when, and the OLD value of ol_quantity
every time the data of table ORDER_LINE is updated.
*/
SPOOL C:\BD2\MercadoRonald_Project10_3.txt
SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON;

connect des02/des02;

CREATE SEQUENCE orderL_audit_seq2;

/*Creation table*/
CREATE TABLE ORDER_LINE_ROW_AUDIT(row_number_id NUMBER, date_updated DATE,
 updating_user VARCHAR2(20), old_ol_quantity NUMBER);

/*Trigger section*/

CREATE OR REPLACE TRIGGER order_line_audit_old
AFTER UPDATE ON order_line
FOR EACH ROW
  BEGIN
    INSERT INTO ORDER_LINE_ROW_AUDIT 
    VALUES(orderL_audit_seq2.NEXTVAL, sysdate, user, :OLD.ol_quantity);
  END;
/

/*Connect second user and do modification of table*/
CONNECT rom/123;

-- Update columns
UPDATE des02.order_line SET ol_quantity = 25
WHERE o_id = 6 AND inv_id = 2;
commit;


-- Check changes did it
connect des02/des02;

SELECT row_number_id, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI:SS Am'), 
updating_user FROM  ORDER_LINE_ROW_AUDIT;


SPOOL OFF;


-------------------------------------------------------------------------------------------------
