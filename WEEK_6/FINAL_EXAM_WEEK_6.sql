-- See contents:
SELECT * FROM chicago_public_schools LIMIT 5;
SELECT * FROM chicago_socioeconomic_data LIMIT 5;
SELECT * FROM chicago_crime LIMIT 5;

--@block
-- FIRST EXERCISE: GET SCHOOL INFORMATION WITH CERTAIN INDEX
SELECT CPS.`NAME_OF_SCHOOL`, CPS.`COMMUNITY_AREA_NAME`, CPS.`AVERAGE_STUDENT_ATTENDANCE`, CSD.`HARDSHIP_INDEX`
FROM chicago_socioeconomic_data CSD
LEFT OUTER JOIN chicago_public_schools CPS 
ON CPS.`COMMUNITY_AREA_NAME` = CSD.`COMMUNITY_AREA_NAME`
WHERE CSD.`hardship_index` = 98;


--@block
-- SECOND EXERCISE: FIND THE NUMBER OF CRIMES
SELECT CC.`CASE_NUMBER`, CC.`PRIMARY_TYPE`, CC.`LOCATION_DESCRIPTION`, CSD.`COMMUNITY_AREA_NAME`
FROM chicago_crime CC  
INNER JOIN chicago_socioeconomic_data CSD
ON CC.`COMMUNITY_AREA_NUMBER` = CSD.`COMMUNITY_AREA_NUMBER`
WHERE CC.`LOCATION_DESCRIPTION` LIKE '%SCHOOL%';

--@block
-- COUNTING THE NUMBER OF ROWS
SELECT COUNT(*) AS 'TOTAL_ROWS' FROM (
    SELECT CC.`CASE_NUMBER`, CC.`PRIMARY_TYPE`, CC.`LOCATION_DESCRIPTION`, CSD.`COMMUNITY_AREA_NAME`
    FROM chicago_crime CC  
    INNER JOIN chicago_socioeconomic_data CSD
    ON CC.`COMMUNITY_AREA_NUMBER` = CSD.`COMMUNITY_AREA_NUMBER`
    WHERE CC.`LOCATION_DESCRIPTION` LIKE '%SCHOOL%'
); -- 12 rows

--@block
-- THIRD EXERCISE: CREATE A VIEW
CREATE VIEW SAFE_INFO (School_Name,Safety_Rating,Family_Rating,Environment_Rating,Instruction_Rating,Leaders_Rating,Teachers_Rating)
AS SELECT NAME_OF_SCHOOL,Safety_Icon,Family_Involvement_Icon,Environment_Icon,Instruction_Icon,Leaders_Icon,Teachers_Icon
FROM chicago_public_schools;

--@block
-- SHOW VIEW SAFE_INFO
SELECT * FROM SAFE_INFO LIMIT 5;

--@block
-- UPDATE_LEADER_SCORES() PROCEDURE:
CREATE PROCEDURE UPDATE_LEADER_SCORES(in_School_ID int, in_Leader_Score int)
BEGIN

    START TRANSACTION;
    UPDATE chicago_public_schools
    SET `Leaders_Score` = in_Leader_Score
    WHERE `School_ID` = in_School_ID;

    CASE
        WHEN in_Leader_Score BETWEEN 80 AND 99 THEN
            UPDATE chicago_public_schools
            SET `Leaders_Icon` = 'Very strong'
            WHERE `School_ID` = in_School_ID;
        
        WHEN in_Leader_Score BETWEEN 60 AND 79 THEN
            UPDATE chicago_public_schools
            SET `Leaders_Icon` = 'Strong'
            WHERE `School_ID` = in_School_ID;

        WHEN in_Leader_Score BETWEEN 40 AND 59 THEN
            UPDATE chicago_public_schools
            SET `Leaders_Icon` = 'Average'
            WHERE `School_ID` = in_School_ID;

        WHEN in_Leader_Score BETWEEN 20 AND 39 THEN
            UPDATE chicago_public_schools
            SET `Leaders_Icon` = 'Weak'
            WHERE `School_ID` = in_School_ID;
    
        WHEN in_Leader_Score BETWEEN 0 AND 19 THEN
            UPDATE chicago_public_schools
            SET `Leaders_Icon` = 'Very weak'
            WHERE `School_ID` = in_School_ID;

        ELSE
            ROLLBACK;

    END CASE;
    COMMIT;
END

--@block
-- ERASE PROCEDURE:
DROP PROCEDURE UPDATE_LEADER_SCORES;

--@block
-- CORROBORATE FUNCTIONALITY:
-- SCHOOL ID: 610038
-- LEADER SCORE: 65
-- LEADER ICON: WEAK
SELECT `School_ID`, `Leaders_Score`,`Leaders_Icon` FROM chicago_public_schools
WHERE `School_ID` = 610038;

CALL UPDATE_LEADER_SCORES(610038,50);

-- Now leader icon is average and leader score is 50.
SELECT `School_ID`, `Leaders_Score`,`Leaders_Icon` FROM chicago_public_schools
WHERE `School_ID` = 610038;


--@block
-- Changing datatype of the column
ALTER TABLE chicago_public_schools 
MODIFY COLUMN `Leaders_Icon` TEXT;


-- Doing the final test:
--@block : In range
CALL UPDATE_LEADER_SCORES(610038,38);
SELECT `School_ID`, `Leaders_Score`,`Leaders_Icon` FROM chicago_public_schools
WHERE `School_ID` = 610038;

--@block : Out of range
CALL UPDATE_LEADER_SCORES(610038,101);
SELECT `School_ID`, `Leaders_Score`,`Leaders_Icon` FROM chicago_public_schools
WHERE `School_ID` = 610038;

--@block
SELECT `School_ID`, `Leaders_Score`,`Leaders_Icon` FROM chicago_public_schools
WHERE `School_ID` = 610038;
