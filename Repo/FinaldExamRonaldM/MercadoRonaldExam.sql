--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: December/14/2022
--Database II
--Description: Final Exam


SPOOL C:\BD2\MercadoRonald_Final_Exam_Q2.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

--Question 2

CREATE OR REPLACE FUNCTION func_inv (p_inv_id NUMBER, p_order_id NUMBER) RETURN NUMBER as

v_subtotal NUMBER;
v_price NUMBER;
v_quantity NUMBER;

begin
  
  SELECT inv_price, ol_quantity  INTO  v_price, v_quantity
  FROM inventory JOIN order_line ON inventory.inv_id = order_line.inv_id
  WHERE inventory.inv_id = p_inv_id AND order_line.o_id = p_order_id;
  
v_subtotal := v_price * v_quantity;
RETURN v_subtotal;

end;
/

--

CREATE OR REPLACE PROCEDURE ronald ( p_inv_id NUMBER , p_order_id NUMBER) as

v_result NUMBER;
v_price NUMBER;
v_quantity NUMBER;

begin


SELECT inv_price, ol_quantity  INTO  v_price, v_quantity
  FROM inventory JOIN order_line ON inventory.inv_id = order_line.inv_id
  WHERE inventory.inv_id = p_inv_id AND order_line.o_id = p_order_id;

  v_result := func_inv( p_inv_id , p_order_id);

DBMS_OUTPUT.PUT_LINE('The subtotal of combination ' ||  p_inv_id || 'and ' || p_order_id || 'is ' || v_result || 'dollar');

exception
  when no_data_found then
   DBMS_OUTPUT.PUT_LINE('The order id or inventory id does not exist');
end;
/

EXEC ronald ( 14 ,1 );

SPOOL OFF;


----------------------------------------------------------------



SPOOL C:\BD2\MercadoRonald_Final_Exam_q3.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON


--Question 3

CREATE OR REPLACE PROCEDURE ronald_q3 AS

  BEGIN
    FOR d IN (SELECT c_id, c_last , c_first FROM customer) LOOP
  
      DBMS_OUTPUT.PUT_LINE('customer ' || d.c_id  || ' ' || d.c_last || ' ' || d.c_first);

    FOR e IN (SELECT o_id , o_date, o_methpmt, os_id FROM orders WHERE c_id = d.c_id) LOOP

       
        DBMS_OUTPUT.PUT_LINE('order id ' || e.o_id  || ' date ' ||
         e.o_date ||' method' || e.o_methpmt || 'os_id ' || e.os_id);
      END LOOP;
    END LOOP;
END;
/
exec ronald_q3;

SPOOL OFF;


---------------------------------------------


--Question 4


SPOOL C:\BD2\MercadoRonald_Final_Exam_q4.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;


SET SERVEROUTPUT ON;

CREATE SEQUENCE seq_audit;

/*Creation table*/
CREATE TABLE audit_consultant_skill (audit_id NUMBER, c_id NUMBER, skill_id NUMBER, certification CHAR(1));

/*Trigger section*/

CREATE OR REPLACE TRIGGER consultant_skill_audit_old
AFTER UPDATE ON consultant_skill
FOR EACH ROW
  BEGIN
    INSERT INTO audit_consultant_skill
    VALUES(seq_audit.NEXTVAL, :OLD.c_id, :OLD.skill_id, :OLD.certification);
  END;
/



SPOOL OFF;



----------------------------------------------------------------------------------------

--Question 5



SPOOL C:\BD2\MercadoRonald_Final_Exam_q5.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON


--Specification

CREATE OR REPLACE PACKAGE ronald_final IS

FUNCTION func_inv ( p_inv_id NUMBER , p_order_id NUMBER) RETURN NUMBER;
PROCEDURE ronald ( p_inv_id NUMBER , p_order_id NUMBER);
PROCEDURE ronald_q3;

END;
/

-------------------- Body Package


CREATE OR REPLACE PACKAGE BODY ronald_final IS

-- Q2 function
FUNCTION func_inv (p_inv_id NUMBER, p_order_id NUMBER) RETURN NUMBER as

v_subtotal NUMBER;
v_price NUMBER;
v_quantity NUMBER;

begin
  
  SELECT inv_price, ol_quantity  INTO  v_price, v_quantity
  FROM inventory JOIN order_line ON inventory.inv_id = order_line.inv_id
  WHERE inventory.inv_id = p_inv_id AND order_line.o_id = p_order_id;
  
v_subtotal := v_price * v_quantity;
RETURN v_subtotal;

end;

--Procedure
PROCEDURE ronald ( p_inv_id NUMBER , p_order_id NUMBER) as

v_result NUMBER;
v_price NUMBER;
v_quantity NUMBER;

begin


SELECT inv_price, ol_quantity  INTO  v_price, v_quantity
  FROM inventory JOIN order_line ON inventory.inv_id = order_line.inv_id
  WHERE inventory.inv_id = p_inv_id AND order_line.o_id = p_order_id;

  v_result := func_inv( p_inv_id , p_order_id);

DBMS_OUTPUT.PUT_LINE('The subtotal of combination ' ||  p_inv_id || 'and ' || p_order_id || 'is ' || v_result || 'dollar');

exception
  when no_data_found then
   DBMS_OUTPUT.PUT_LINE('The order id or inventory id does not exist');
end;

-- Q3

PROCEDURE ronald_q3 AS

  BEGIN
    FOR d IN (SELECT c_id, c_last , c_first FROM customer) LOOP
  
      DBMS_OUTPUT.PUT_LINE('customer ' || d.c_id  || ' ' || d.c_last || ' ' || d.c_first);

    FOR e IN (SELECT o_id , o_date, o_methpmt, os_id FROM orders WHERE c_id = d.c_id) LOOP

       
        DBMS_OUTPUT.PUT_LINE('order id ' || e.o_id  || ' date ' ||
         e.o_date ||' method' || e.o_methpmt || 'os_id ' || e.os_id);
      END LOOP;
    END LOOP;
END;

END;
/

SPOOL OFF;