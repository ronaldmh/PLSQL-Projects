

connect des02/des02;

-- Specification

CREATE OR REPLACE PACKAGE order_package IS
      global_inv_id NUMBER(6);
      global_quantity NUMBER(6);
      PROCEDURE create_new_order(current_c_id NUMBER,current_meth_pmt VARCHAR2,current_os_id NUMBER);
      PROCEDURE create_new_order_line(current_o_id NUMBER);
    END;
    /


CREATE SEQUENCE order_seq START WITH 1000;

-- Body

CREATE OR REPLACE PACKAGE BODY order_package IS

      PROCEDURE create_new_order(current_c_id NUMBER, 
                               current_meth_pmt VARCHAR2, 
                                 current_os_id NUMBER) AS
              current_o_id NUMBER;
            BEGIN
               SELECT order_seq.NEXTVAL
               INTO   current_o_id
               FROM   dual;

               INSERT INTO orders 
     VALUES(current_o_id, sysdate, current_meth_pmt,current_c_id, current_os_id);

               create_new_order_line(current_o_id);

             COMMIT;
            END create_new_order;

      PROCEDURE create_new_order_line(current_o_id NUMBER) AS
            BEGIN
               INSERT INTO order_line 
               VALUES(current_o_id, global_inv_id, global_quantity);
               COMMIT;
            END create_new_order_line;
    END;
    /


 BEGIN
  order_package.global_inv_id := 32;
  order_package.global_quantity := 99;
END;
/ 


create or replace procedure USE_PACKAGE AS
BEGIN
  order_package.create_new_order(4,'CASH',5);
END;
/

-- select * from orders; (6 rows)
-- select * from order_line; (10 rows)
-- select * from inventory;


BEGIN
  
  INSERT INTO inventory (inv_qoh)
  VALUES(10)
  WHERE inv_id = 32;
  COMMIT;

  END;
/



PROCEDURE verif_qoh(global_inv_id NUMBER) AS
            
            v_item_id inventory.item_id%TYPE;
            v_color inventory.color%TYPE; 
            v_inv_size inventory.inv_size%TYPE; 
            v_price inventory.inv_price%TYPE; 
            v_qoh inventory.inv_qoh%TYPE;
            v_inv_id inventory.inv_id%TYPE;
                      
            
            BEGIN
              SELECT inv_id,item_id, color, inv_size, inv_price, inv_qoh 
              INTO v_inv_id,v_item_id, v_color, v_inv_size, v_price, v_qoh         
              FROM inventory WHERE inv_id = global_inv_id;
            
                IF v_qoh > global_quantity THEN
                   
                  INSERT INTO inventory (inv_id, item_id, color, inv_size, inv_price, inv_qoh)
                  VALUES (v_inv_id, v_item_id, v_color, v_inv_size, v_price,(v_qoh - global_quantity));
                  COMMIT;              


