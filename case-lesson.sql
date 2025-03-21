/*
SQL Course - CASE Lesson
We can add a new calculated columns and use CASE as a switch between options.
*/

/*
A "simple form" CASE statement based on the values of a single column
*/

SELECT
    ps.PatientId
    
    ,ps.Hospital
    
    ,CASE
        ps.Hospital
        WHEN 'PRUH' THEN 'Princess Royal University Hospital'
        WHEN 'Oxleas' THEN 'Oxleas NHS Foundation Trust'
        ELSE 'Other Hospitals'
    END AS HospitalGroup
    
    ,ps.Ward
FROM
    dbo.PatientStay ps
ORDER BY
    HospitalGroup;

/*
A "searched form" CASE statement based on a boolean condition
*/

SELECT
    ps.PatientId
    
    ,ps.Hospital
    
    ,ps.Ward
    
    ,CASE
        WHEN ps.Ward LIKE '%Surgery' THEN 'Surgical'
        WHEN ps.Ward IN ('Accident', 'Emergency', 'Ophthalmology') THEN 'A&E'
        ELSE 'General'
    END AS WardType
FROM
    dbo.PatientStay ps
ORDER BY WardType;

/*
 * A common pattern is to use a SUM(CASE ... WHEN ... THEN 1 ELSE 0 END) calculation
 * to count where the number of rows where a condition occurs
 */

SELECT
    ps.Hospital
    
    ,COUNT(*) AS NumberOfPatients
    
    ,SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END) AS NumberOfPatientsInSurgery
    
    ,Round((100.0 * SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END)) / COUNT(*),1) AS PercentageOfPatientsInSurgery
FROM
    dbo.PatientStay ps
GROUP BY ps.Hospital
ORDER BY ps.Hospital


/*
Optional advanced section
 
A more complex "searched form" CASE syntax statement  for more general cases
Assume that the Financial Year starts on March 1st
*/
SELECT
    ps.PatientId
    
    ,ps.AdmittedDate
    
    ,CASE
        WHEN DATEPART(MONTH, ps.AdmittedDate) >= 3 -- March or later in the year
    THEN     CONCAT('FY-', DATEPART(YEAR, ps.AdmittedDate), '-', DATEPART(YEAR, ps.AdmittedDate) + 1)
        ELSE CONCAT('FY-', DATEPART(YEAR, ps.AdmittedDate) - 1, '-', DATEPART(YEAR, ps.AdmittedDate))
    END AS FinancialYear
FROM
    dbo.PatientStay ps
WHERE ps.Hospital = 'PRUH'
ORDER BY ps.AdmittedDate,
         ps.PatientId;




--Exercises--

/*
* SQL Course - CASE Exercise - Start
*/

/*
 * Create a new column HospitalLocation
 * Kings College is Urban, other hospitals are Rural
 * Use the simple CASE form
*/

SELECT
    ps.PatientId
    ,ps.Hospital
    ,CASE ps.Hospital       --Case when a Column--
    WHEN 'Kings College' THEN 'Urban' 
    ELSE 'Other' END AS HospitalLocation
-- Simple Case--

FROM
    dbo.PatientStay ps
ORDER BY
    HospitalLocation;

/*
 * Create a new column WardType
 * Any ward that contains 'Surgery' is 'Surgical', otherwise 'Non Surgical'
 * Use the searched CASE form
*/

SELECT
    ps.PatientId
    ,ps.Ward
    ,ps.Hospital
    ,CASE   --Case when a Column contains (LIKE)--
    WHEN ps.Ward LIKE '%Surgery'THEN 'Surgical'
    ELSE 'Non-Surgical' END AS WardType

FROM
    dbo.PatientStay ps
ORDER BY
    WardType;

/*
 * Create a new column PatientTariffGroup
 * A patient with a Tariff of 7 or more is in the 'High Tariff' group
 * A patient with a Tariff of 4 or more but below 7 is in the 'Medium Tariff' group
 * A patient with a Tariff below 4 is is in the 'Low Tariff' group
 *
 * Optional advanced question: how many patients are in each PatientTariffGroup?
 */

SELECT
    ps.PatientId
    ,ps.AdmittedDate
    ,ps.Tariff
    ,CASE 
    WHEN ps.Tariff >=7 THEN 'High' 
    WHEN ps.Tariff >=4 THEN 'Medium'
    ELSE 'Low' 
    END 
    AS PatientTariffGroup
--- CASE Search---
FROM
    dbo.PatientStay ps
ORDER BY
    PatientTariffGroup
    , ps.Tariff
    , ps.PatientId;
 