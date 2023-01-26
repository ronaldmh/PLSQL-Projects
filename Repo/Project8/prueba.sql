
CREATE SEQUENCE order_sequence2 START WITH 8;


CREATE OR REPLACE PROCEDURE prueba (current_c_id NUMBER,current_meth_pmt VARCHAR2,current_os_id NUMBER) AS

current_o_id NUMBER;

SELECT order_sequence2.NEXTVAL
               INTO   current_o_id
               FROM   dual;  

begin

  INSERT INTO orders 
              VALUES(current_o_id, sysdate, current_meth_pmt,current_c_id, current_os_id);
              
end;
/