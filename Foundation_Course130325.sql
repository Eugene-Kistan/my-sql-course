SELECT
    PS.[PatientId]   
    ,PS.[AdmittedDate]  
    ,PS.[DischargeDate]
    ,DATEDIFF(DAY,AdmittedDate,DischargeDate) AS LengthOfStay
    ,PS.[Hospital]  
    ,PS.[Ward]
    ,PS.[Tariff]
FROM
    [dbo].[Patientstay] PS
WHERE 
      PS.[Hospital] IN('Oxleas','PRUH')
    AND PS.Ward LIKE'%Surgery'
    AND PS.AdmittedDate BETWEEN'2024-02-01'AND'2024-02-29'
    AND PS.Tariff > 5

--Summarising Data

SELECT
    PS.Hospital
    ,COUNT(*) AS NumberOfPatients
    ,SUM(ps.Tariff) AS TotalTariff
    ,AVG(ps.Tariff) AS AvgTariff
    ,SUM(ps.Tariff) / COUNT(*) AS AvgTariff2
FROM
    PatientStay PS
GROUP BY PS.Hospital
HAVING COUNT(*) > 10
ORDER BY NumberOfPatients DESC


--Order of Execution
--FROM
--WHERE
--GROUP BY
--SELECT
--ORDER BY

SELECT
    *
FROM
    DimHospital
SELECT
    *
FROM
    PatientStay

SELECT
    ps.PatientId
    ,ps.AdmittedDate
    ,ps.Hospital
    ,h.Hospital
    ,h.HospitalSize
FROM
    PatientStay ps JOIN DimHospital h
    ON ps.Hospital = h.Hospital

---Practice

SELECT
    TOP 10
    *
FROM
    PricePaidSW12

SELECT
    YEAR(pps.TransactionDate)
    ,COUNT(*) AS NumberOfSales
    ,SUM(pps.Price) AS TotalPrice
FROM
    PricePaidSW12 pps
GROUP BY YEAR(pps.TransactionDate)
ORDER BY YEAR(pps.TransactionDate)

SELECT
    YEAR(CAST(GETDATE() AS DATE))

SELECT
    pps.TransactionDate
    ,pps.Price
    ,pps.PAON
    ,pps.SAON
    --,pps.PropertyType
    ,pt.PropertyTypeName
FROM
    PricePaidSW12 pps JOIN PropertyTypeLookup pt ON pps.PropertyType = pt.PropertyTypeCode
WHERE pps.Street = 'Cambray Road'
    AND pps.Price BETWEEN 400000 AND 500000
    AND pps.PropertyType = 'T'
    AND pps.PAON % 2 = 1 -- odd # south facing






















