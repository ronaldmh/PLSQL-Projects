--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: November/13/2022
--Database II
--Description: Project V7

connect sys/sys as sysdba;

SPOOL C:\BD2\MercadoRonaldPrj7.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

--Question 1 - CHECK

connect des03/des03;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE members AS
     
    CURSOR members_curr IS
      SELECT f_id,f_last, f_first, f_rank
      FROM   faculty;
        
	 CURSOR students_curr (p_f_id IN NUMBER) IS
       SELECT s_id, s_last, s_first, s_dob, s_class
       FROM   student
	    WHERE  f_id = p_f_id ;      

BEGIN
 
  FOR a IN members_curr LOOP
       DBMS_OUTPUT.PUT_LINE('--------------------------');
   DBMS_OUTPUT.PUT_LINE('ID: ' || a.f_id ||
  ' last name: ' ||a.f_last || ' name: ' ||
    a.f_first ||' Rank: ' || a.f_rank );

            -- inner cursor
         FOR e IN students_curr(a.f_id) LOOP
         DBMS_OUTPUT.PUT_LINE('Student Id:  ' || e.s_id ||
  ' last name: ' ||e.s_last || ' name: ' ||e.s_first
    || ' birthday ' ||e.s_dob ||' Class: '|| e.s_class );
          
    END LOOP;
  END LOOP;
END;
/

EXEC members;

-- Question 2 -- CHECK

connect des04/des04;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE consultants AS

	CURSOR consul_curr IS
	SELECT c_id, c_first, c_last
	FROM consultant;

v_con_row consul_curr%ROWTYPE;

	CURSOR skills_curr (p_c_id IN NUMBER) IS
	SELECT skill_description, certification 
	FROM skill
	JOIN consultant_skill ON consultant_skill.skill_id = skill.skill_id	
	WHERE c_id =  p_c_id;

v_skills_row skills_curr%ROWTYPE;


BEGIN

FOR v_con_row IN consul_curr LOOP
	 DBMS_OUTPUT.PUT_LINE('--------------------------');
     DBMS_OUTPUT.PUT_LINE('ID: ' || v_con_row.c_id ||', last name: '||v_con_row.c_last || ', first name: ' || v_con_row.c_first);

FOR v_skills_row IN skills_curr(v_con_row.c_id) LOOP
     DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skills_row.skill_description || ' ,Certification: ' || v_skills_row.certification);
	    
    END LOOP;
  END LOOP;
END;
/
EXEC consultants;


--Question 3 - CHECK


connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE allItems AS

BEGIN

FOR a IN (SELECT item_id, item_desc, cat_id FROM item) LOOP

DBMS_OUTPUT.PUT_LINE('--------------------------');
     DBMS_OUTPUT.PUT_LINE('item id: ' || a.item_id ||' '||a.item_desc || ', cat: ' || a.cat_id);
	DBMS_OUTPUT.PUT_LINE('has the following inventories: ');

FOR b IN (SELECT inv_id  FROM inventory WHERE item_id = a.item_id) LOOP
     DBMS_OUTPUT.PUT_LINE('Id: ' || b.inv_id);
	
   END LOOP;
END LOOP;
   
END;
/
EXEC allItems;


--Question 4 - CHECK

connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE allItems2 AS

 v_value NUMBER;

BEGIN

FOR a IN (SELECT item_id, item_desc, cat_id FROM item) LOOP

DBMS_OUTPUT.PUT_LINE('--------------------------');
     DBMS_OUTPUT.PUT_LINE('item id: ' || a.item_id ||' '||a.item_desc || ', cat: ' || a.cat_id);
	DBMS_OUTPUT.PUT_LINE('has the following inventories: ');	

FOR b IN (SELECT inv_id, inv_price, inv_qoh   FROM inventory WHERE item_id = a.item_id) LOOP

 v_value := b.inv_price * b.inv_qoh;

     DBMS_OUTPUT.PUT_LINE('Id: ' || b.inv_id || ', price: ' || b.inv_price || ', Qoh : ' || b.inv_qoh || ', Value : ' || v_value );
	
   END LOOP;
END LOOP;
   
END;
/
EXEC allItems2;

-- END PROJECT 7

SPOOL OFF;

