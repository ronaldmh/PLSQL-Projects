--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: November/17/2022
--Database II
--Description: Project V8

connect sys/sys as sysdba;

SPOOL C:\BD2\MercadoRonaldPrj8.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

--Question 1 -

--Specification

CREATE OR REPLACE PACKAGE order_package IS
      global_inv_id NUMBER(6);
      global_quantity NUMBER(6);
      
      PROCEDURE create_new_order(current_c_id NUMBER,current_meth_pmt VARCHAR2,current_os_id NUMBER);
      PROCEDURE create_new_order_line(current_o_id NUMBER);
      PROCEDURE verif_qoh(global_inv_id NUMBER);
    END;
    /

-- Body

CREATE SEQUENCE order_sequence START WITH 7;


CREATE OR REPLACE PACKAGE BODY order_package IS

                     
      
      PROCEDURE create_new_order(current_c_id NUMBER,current_meth_pmt VARCHAR2,current_os_id NUMBER) AS
              
              current_o_id NUMBER;
            
            BEGIN
               SELECT order_sequence.NEXTVAL
               INTO   current_o_id
               FROM   dual;              

              INSERT INTO orders 
              VALUES(current_o_id, sysdate, current_meth_pmt,current_c_id, current_os_id);

              verif_qoh(global_inv_id);
               /*create_new_order_line(current_o_id);*/
             COMMIT;
            END create_new_order;




            PROCEDURE verif_qoh(global_inv_id NUMBER) AS
            
            v_qoh NUMBER;
            v_current_o_id NUMBER;
            
            BEGIN
              SELECT inv_qoh
              INTO v_qoh            
              FROM inventory WHERE inv_id = global_inv_id;

              SELECT o_id
              INTO v_current_o_id
              FROM orders;              

            
                IF v_qoh > global_quantity THEN
                   create_new_order_line(v_current_o_id);
                   DBMS_OUTPUT.PUT_LINE('v_qoh > global_quantity');                 
                
                ELSIF v_qoh = global_quantity THEN
                  create_new_order_line(v_current_o_id);
                   DBMS_OUTPUT.PUT_LINE('v_qoh = global_quantity');                 

                ELSIF v_qoh < global_quantity THEN
                  create_new_order_line(v_current_o_id);
                   DBMS_OUTPUT.PUT_LINE('v_qoh < global_quantity');

                ELSIF v_qoh = 0 THEN
                
                   DBMS_OUTPUT.PUT_LINE('0');
                  

                END IF;             

            COMMIT;
            END verif_qoh;

      
      
      PROCEDURE create_new_order_line(current_o_id NUMBER) AS
            BEGIN
               INSERT INTO order_line 
               VALUES(current_o_id, global_inv_id, global_quantity);
               COMMIT;
            END create_new_order_line;
    END;
    /



-- set the global variable

 BEGIN
  order_package.global_inv_id := 25;
  order_package.global_quantity := 1;
END;
/

--test 

create or replace procedure USE_PACKAGE AS
BEGIN
  order_package.create_new_order(5,'CASH2',5);
  
END;
/


--drop sequence name 
--create sequence name START WITH 1000

-- END PROJECT 8

SPOOL OFF;

