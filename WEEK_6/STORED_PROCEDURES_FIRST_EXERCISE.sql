-- This will create the procedure in the database.
CREATE PROCEDURE RETRIEVE_ALL()
BEGIN
   SELECT *  FROM PETSALE;
END

--@block
-- Review that the procedure was stored properly.
SHOW PROCEDURE STATUS LIKE 'RETRIEVE_ALL';


--@block
-- This will retrieve the procedure.
CALL RETRIEVE_ALL;

--@block
-- This will drop the stored procedure'
DROP PROCEDURE RETRIEVE_ALL;
CALL RETRIEVE_ALL;
--SHOW PROCEDURE STATUS;
