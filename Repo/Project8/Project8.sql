--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: November/17/2022
--Database II
--Description: Project V8

connect sys/sys as sysdba;

SPOOL C:\BD2\MercadoRonaldPrj8.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

--Question 1 -

connect des02/des02;

--Specification

CREATE OR REPLACE PACKAGE order_package IS
      global_inv_id NUMBER(6);
      global_quantity NUMBER(6);
      current_o_id NUMBER;

      PROCEDURE create_new_order(current_c_id NUMBER,current_meth_pmt VARCHAR2,current_os_id NUMBER);
      PROCEDURE create_new_order_line(current_o_id NUMBER);
      PROCEDURE verif_qoh(global_inv_id NUMBER);
    END;
    /

-- Body

CREATE SEQUENCE counter START WITH 7;

CREATE OR REPLACE PACKAGE BODY order_package IS                     
      
      PROCEDURE create_new_order(current_c_id NUMBER,current_meth_pmt VARCHAR2,current_os_id NUMBER) AS                         
            
            BEGIN
               SELECT counter.NEXTVAL
               INTO   current_o_id
               FROM   dual;              

              INSERT INTO orders 
              VALUES(current_o_id, sysdate, current_meth_pmt,current_c_id, current_os_id);            
                            
             COMMIT;
             verif_qoh(global_inv_id);
            END create_new_order;
                      
--------------------------------------------------------------------------------------------------------------

      PROCEDURE verif_qoh(global_inv_id NUMBER) AS
            
            v_qoh inventory.INV_QOH%TYPE;
            
            BEGIN
              SELECT INV_QOH INTO v_qoh
              FROM inventory      
              WHERE INV_ID = global_inv_id;
            
                IF  v_qoh > global_quantity THEN
                   
                   v_qoh := v_qoh - global_quantity;

                   UPDATE inventory SET INV_QOH = v_qoh WHERE INV_ID = global_inv_id;

                  COMMIT;
                  
                  create_new_order_line(current_o_id);
                
                ELSIF v_qoh = global_quantity THEN

                  UPDATE inventory SET INV_QOH = 0 WHERE INV_ID = global_inv_id;
                  
                    COMMIT;          

                  create_new_order_line(current_o_id);                                                  

                
                ELSIF v_qoh = 0 THEN                
                   
                  DBMS_OUTPUT.PUT_LINE('Global quantity  '|| global_quantity || 'WILL BE available VERY VERY VERY SOON'); 
                
                
                ELSIF v_qoh < global_quantity THEN
                  
                  UPDATE inventory SET INV_QOH = 0 WHERE INV_ID = global_inv_id;

                  COMMIT; 
                 
                  DBMS_OUTPUT.PUT_LINE('Global quantity = '|| global_quantity || ' - ' || 'INV_QOH = ' || v_qoh || 'WILL BE available VERY VERY VERY SOON');

                  create_new_order_line(current_o_id);

                END IF;            

            COMMIT;
             create_new_order_line(current_o_id); 
            END verif_qoh;

---------------------------------------------------------------------------------------------------------------------
      
      PROCEDURE create_new_order_line(current_o_id NUMBER) AS
            BEGIN
               INSERT INTO order_line (O_ID, INV_ID, OL_QUANTITY)
               VALUES(current_o_id, global_inv_id, global_quantity);
               COMMIT;
            END create_new_order_line;
    END;
    /

---------------------------------------------- END BODY------------------------------------------------------------------

-- set the global variable

BEGIN
  order_package.global_inv_id := 28;
  order_package.global_quantity := 20;
END;
/
--test 

exec order_package.create_new_order(4,'VISA',5);


BEGIN
  order_package.global_inv_id := 16;
  order_package.global_quantity := 11;
END;
/

exec order_package.create_new_order(4,'CRYPTO',5);

select * from orders;
select * from order_line;
select * from inventory;


SPOOL OFF;

-------------------------------------------------------------------------------------------------------------

connect des04/des04;
SET SERVEROUTPUT ON

SPOOL C:\BD2\MercadoRonaldPrj8_2.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;


--Question 2 -

CREATE OR REPLACE PACKAGE skill_package IS
      global_c_id NUMBER(6);     
      PROCEDURE newSkill(p_cons_id NUMBER, p_skill_id NUMBER, p_cert VARCHAR2);
      PROCEDURE displayConsultants(p_cons_id NUMBER);      
END;
/

-- Body

CREATE OR REPLACE PACKAGE BODY skill_package is

  PROCEDURE newSkill(p_cons_id NUMBER, p_skill_id NUMBER, p_cert VARCHAR2) AS

    BEGIN  
        INSERT INTO consultant_skill (c_id, skill_id, certification)
        VALUES(p_cons_id, p_skill_id, p_cert);    
        COMMIT;
        displayConsultants(p_cons_id);
  END newSkill;


------------------------------------------------------------------------------------------------------------------------------


  PROCEDURE displayConsultants(p_cons_id NUMBER) AS

    CURSOR consul_curr IS
      SELECT c_id, c_first, c_last
      FROM consultant;

      v_con_row consul_curr%ROWTYPE;

      CURSOR skills_curr (p_cons_id IN NUMBER) IS
      SELECT skill_description, certification 
      FROM skill
      JOIN consultant_skill ON consultant_skill.skill_id = skill.skill_id	
      WHERE c_id =  p_cons_id;

      v_skills_row skills_curr%ROWTYPE;

    
    BEGIN
      
      FOR v_con_row IN consul_curr LOOP
        DBMS_OUTPUT.PUT_LINE('--------------------------');
          DBMS_OUTPUT.PUT_LINE('ID: ' || v_con_row.c_id ||', last name: '||v_con_row.c_last || ', first name: ' || v_con_row.c_first);

        FOR v_skills_row IN skills_curr(v_con_row.c_id) LOOP
            DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skills_row.skill_description || ' ,Certification: ' || v_skills_row.certification);
              
        END LOOP;
      END LOOP;
  END displayConsultants;
END;
/

exec skill_package.newSkill(100,2,'Y');

-- END PROJECT 8

SPOOL OFF;

