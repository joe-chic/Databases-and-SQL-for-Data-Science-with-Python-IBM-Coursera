-- Create 
CREATE PROCEDURE UPDATE_SALEPRICE (IN Animal_ID INTEGER, IN Animal_Health VARCHAR(5))
BEGIN
    IF Animal_Health = 'BAD' THEN
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.25)
        WHERE ID = Animal_ID;
    ELSEIF Animal_Health = 'WORSE' THEN
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.5)
        WHERE ID = Animal_ID;
    ELSE
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE
        WHERE ID = Animal_ID;
    END IF;
END

--@block
-- CALL RETRIEVE_ALL;
-- CALL UPDATE_SALEPRICE(1,'BAD');
CALL RETRIEVE_ALL;


--@block
-- CALL RETRIEVE_ALL;
-- CALL UPDATE_SALEPRICE(3, 'WORSE');
CALL RETRIEVE_ALL;

--@block
-- Drop the procedure.
DROP PROCEDURE UPDATE_SALEPRICE;
CALL UPDATE_SALEPRICE;