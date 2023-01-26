

--Procedure 1
  CREATE OR REPLACE PROCEDURE newStud_insert(P_stud_id NUMBER, P_lastName VARCHAR2) AS
  
  v_name VARCHAR2(20);

  BEGIN
      
    SELECT s_last
    INTO v_name
    FROM student
    WHERE s_id = P_stud_id;

    DBMS_OUTPUT.PUT_LINE('ID STUDENT IS ALREADY BEEN USED');    
    
    EXCEPTION
    WHEN no_data_found THEN
        INSERT INTO student(s_id, s_last)
        VALUES(P_stud_id, P_lastName);
    DBMS_OUTPUT.PUT_LINE('NEW STUDENT HAS BEEN INSERTED');
 
 END;
/

EXEC newStud_insert(101,'MONTOYA');


--Procedure 3

CREATE SEQUENCE student_sequence START WITH 7;

CREATE OR REPLACE PROCEDURE newStud_insert(P_lastName VARCHAR2, P_Address VARCHAR2) AS

  BEGIN
    INSERT INTO student(s_id, s_last, s_address)
    VALUES(student_sequence.NEXTVAL, P_lastName, P_Address);
    COMMIT;
END;
/

EXEC newStud_insert('Ronald','MONTOYA');




 --Procedure 4
CREATE OR REPLACE PROCEDURE newStud_insert(P_lastName VARCHAR2, P_Name VARCHAR2, P_birthdate DATE, P_faculty_id NUMBER) AS

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
/

EXEC newStud_insert('MONTOYA', 'Lina', '19/04/1991', 1);





