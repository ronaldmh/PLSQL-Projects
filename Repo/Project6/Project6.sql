--Name: Ronald Mauricio Mercado Herrera
--Cod 2210329
--Date: October/24/2022
--Database II
--Description: Project V6

connect sys/sys as sysdba;

SPOOL C:\BD2\MercadoRonaldPrj6.txt

SELECT to_char(sysdate,'DD Month YYYY Year Day HH:MI:SS Am') FROM dual;

--Question 1 - Check

connect des03/des03;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE members AS
  
    CURSOR members_curr IS
      SELECT f_id,f_last, f_first, f_rank
      FROM   faculty;
  v_members_row members_curr%ROWTYPE;
       
	 CURSOR students_curr (p_f_id IN NUMBER) IS
       SELECT s_id, s_last, s_first, s_dob, s_class
       FROM   student
       WHERE  f_id = p_f_id ;
  v_students_row students_curr%ROWTYPE;

BEGIN
  -- step 2
   OPEN members_curr;
  -- step 3
   FETCH members_curr INTO v_members_row;
     WHILE members_curr%FOUND LOOP
       DBMS_OUTPUT.PUT_LINE('--------------------------');
   DBMS_OUTPUT.PUT_LINE('ID: ' || v_members_row.f_id ||
  ' last name: ' ||v_members_row.f_last || ' name: ' ||
    v_members_row.f_first ||' Rank: ' || v_members_row.f_rank );

            -- inner cursor
          OPEN students_curr   (v_members_row.f_id);
          FETCH students_curr INTO v_students_row;
             WHILE students_curr%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('Student Id:  ' || v_students_row.s_id ||
  ' last name: ' ||v_students_row.s_last || ' name: ' ||v_students_row.s_first
    || ' birthday ' ||v_students_row.s_dob ||' Class: '|| v_students_row.s_class );
          FETCH students_curr INTO v_students_row;
             END LOOP;
       CLOSE students_curr;
FETCH members_curr INTO v_members_row;
   
   END LOOP;
  -- step 4
  CLOSE members_curr;
END;
/

EXEC members;


-- Question 2 -- Check


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
	WHERE p_c_id = c_id;

v_skills_row skills_curr%ROWTYPE;

BEGIN

   OPEN consul_curr;
   FETCH consul_curr INTO v_con_row;
     WHILE consul_curr%FOUND LOOP
	 DBMS_OUTPUT.PUT_LINE('--------------------------');
     DBMS_OUTPUT.PUT_LINE('ID: ' || v_con_row.c_id ||', '||v_con_row.c_last || ' ' || v_con_row.c_first);

	OPEN skills_curr (v_con_row.c_id) ;
    FETCH skills_curr INTO v_skills_row;
     WHILE skills_curr%FOUND LOOP
	 
     DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skills_row.skill_description || ' ,Certification: ' || v_skills_row.certification);
	 FETCH skills_curr INTO v_skills_row;
   END LOOP;
   CLOSE skills_curr;

   -- close main cursor	
	FETCH consul_curr INTO v_con_row;
	END LOOP;
    CLOSE consul_curr;

END;
/
EXEC consultants;


--Question 3 - Check


connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE allItems AS

	CURSOR items_curr IS
	SELECT item_id, item_desc, cat_id
	FROM item;
v_items items_curr%ROWTYPE;

	CURSOR inv_curr (p_item_id IN NUMBER) IS
	SELECT inv_id 
	FROM inventory
	WHERE item_id = p_item_id;
v_inv inv_curr%ROWTYPE;

BEGIN

   OPEN items_curr;
   FETCH items_curr INTO v_items;
     
	 WHILE items_curr%FOUND LOOP
	 DBMS_OUTPUT.PUT_LINE('--------------------------');
     DBMS_OUTPUT.PUT_LINE('item id: ' || v_items.item_id ||' '||v_items.item_desc || ', cat: ' || v_items.cat_id);
	DBMS_OUTPUT.PUT_LINE('has the following inventories: ');
	
	OPEN inv_curr (v_items.item_id) ;
    FETCH inv_curr INTO v_inv;
     WHILE inv_curr%FOUND LOOP
	 
     DBMS_OUTPUT.PUT_LINE('Id: ' || v_inv.inv_id);
	 FETCH inv_curr INTO v_inv;
   END LOOP;
   CLOSE inv_curr;

   -- close main cursor
	
	FETCH items_curr INTO v_items;
	END LOOP;
    CLOSE items_curr;

END;
/
EXEC allItems;


--Question 4 - Check

connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE allItems2 AS

	CURSOR items_curr IS
	SELECT item_id, item_desc, cat_id
	FROM item;
v_items items_curr%ROWTYPE;

	CURSOR inv_curr (p_item_id IN NUMBER) IS
	SELECT inv_id, inv_price, inv_qoh 
	FROM inventory
	WHERE item_id = p_item_id;
v_inv inv_curr%ROWTYPE;

v_value NUMBER;

BEGIN

   OPEN items_curr;
   FETCH items_curr INTO v_items;
     WHILE items_curr%FOUND LOOP
	 DBMS_OUTPUT.PUT_LINE('--------------------------');
     DBMS_OUTPUT.PUT_LINE('item id:' || v_items.item_id ||' '||v_items.item_desc || ', cat: ' || v_items.cat_id);
	DBMS_OUTPUT.PUT_LINE('has the following inventories: ');
	
	OPEN inv_curr (v_items.item_id) ;
    FETCH inv_curr INTO v_inv;
     WHILE inv_curr%FOUND LOOP	 
	 
	 v_value := v_inv.inv_price * v_inv.inv_qoh;
     
	 DBMS_OUTPUT.PUT_LINE('Id: ' || v_inv.inv_id || ', price: ' || v_inv.inv_price || ', Qoh : ' || v_inv.inv_qoh || ', Value : ' || v_value );
	 FETCH inv_curr INTO v_inv;
   END LOOP;
   CLOSE inv_curr;

   -- close main cursor
	
	FETCH items_curr INTO v_items;
	END LOOP;
    CLOSE items_curr;
END;
/
EXEC allItems2;


--Question 5 -


connect des04/des04;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE skillConsultant (p_consultant_id IN NUMBER, p_certYN_in IN CHAR) AS

	CURSOR consul_curr IS
	SELECT c_id, c_first, c_last
	FROM consultant;
v_con_row consul_curr%ROWTYPE;

	CURSOR skills_curr (p_c_id IN NUMBER) IS
	SELECT skill_description, certification 
	FROM skill JOIN consultant_skill ON consultant_skill.skill_id = skill.skill_id
	WHERE p_c_id = c_id;
	FOR UPDATE OF certification;
v_skills_row skills_curr%ROWTYPE;
v_oldCert skills_curr%ROWTYPE;

BEGIN

   OPEN consul_curr;
   FETCH consul_curr INTO v_con_row;
     WHILE consul_curr%FOUND LOOP
	 DBMS_OUTPUT.PUT_LINE('--------------------------');
     DBMS_OUTPUT.PUT_LINE('ID: ' || v_con_row.c_id ||', '||v_con_row.c_last || ' ' || v_con_row.c_first);

OPEN skills_curr (v_con_row.c_id);
    FETCH skills_curr INTO v_skills_row;
     WHILE skills_curr%FOUND LOOP

	 v_oldCert :=v_skills_row.certification;     
		
	UPDATE skill SET certification = p_certYN_in
     WHERE CURRENT OF skills_curr; -- to locate the row to be updated

	 DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skills_row.skill_description || ' ,OLD status : ' || v_oldCert ||' ,NEW status : ' || v_skills_row.certification);
	  
	 FETCH skills_curr INTO v_skills_row;
   END LOOP;
CLOSE skills_curr;

   -- close main cursor	
	FETCH consul_curr INTO v_con_row;
	END LOOP;
	COMMIT;
    CLOSE consul_curr;

END;
/
EXEC skillConsultant(100,'Y');

-- END PROJECT 6

SPOOL OFF;

