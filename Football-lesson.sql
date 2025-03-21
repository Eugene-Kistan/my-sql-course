SELECT
    *
FROM
    FootballMatch

--Home team perspective--
    SELECT
        HomeTeam AS Team
,FTHG AS Scored
,FTAG AS Concerded
    FROM
        FootballMatch
UNION ALL
    --Away home team perspective--
    SELECT
        AwayTeam AS Team
,FTAG AS Scored
,FTHG AS Concerded
    FROM
        FootballMatch

--CTE Approach
;
WITH
    results
    (
        Team
        ,Scored
        ,Concerded
    )
    AS
    (
                    SELECT
                HomeTeam --Home team perspective--
,FTHG 
,FTAG
            FROM
                FootballMatch
        UNION ALL

            SELECT
                AwayTeam --Away home team perspective--
,FTAG
,FTHG
            FROM
                FootballMatch
    )
SELECT
    results.Team
,SUM(results.Scored) AS [For]
,SUM(results.Concerded) AS [Against]
FROM
    results
GROUP BY results.Team

--subquery approach

;
SELECT
    results.Team
,SUM(results.Scored) AS [For]
,SUM(results.Concerded) AS [Against]

FROM( 
                            SELECT
            HomeTeam AS Team
,FTHG AS Scored
,FTAG AS Concerded
        FROM
            FootballMatch
    UNION ALL
        --Away home team perspective--
        SELECT
            AwayTeam AS Team
,FTAG AS Scored
,FTHG AS Concerded
        FROM
            FootballMatch ) results
GROUP BY results.Team

--temp table approach

DROP TABLE IF EXISTS #results

    SELECT
        HomeTeam AS Team --Home team perspective--
,FTHG AS Scored
,FTAG AS Concerded
INTO #results
    FROM
        FootballMatch
UNION ALL
    SELECT
        AwayTeam AS Team --Away home team perspective--
,FTAG AS Scored
,FTHG AS Concerded
    FROM
        FootballMatch

SELECT
    *
FROM
    #results

SELECT
    #results.Team
,SUM(#results.Scored) AS [For]
,SUM(#results.Concerded) AS [Against]
FROM
    #results
GROUP BY #results.Team


---CTE Approach
;
WITH results (Team, Scored, Conceded) AS
(
SELECT
    HomeTeam
    , FTHG
    , FTAG
 FROM FootballMatch
UNION ALL
SELECT
    AwayTeam
    , FTAG
    , FTHG
 FROM FootballMatch
),
League_Table AS (

SELECT
    results.Team
    ,COUNT(*) AS Played
    ,SUM(CASE WHEN Scored > Conceded THEN 1 ELSE 0 END) AS Won
    ,SUM(CASE WHEN Scored = Conceded THEN 1 ELSE 0 END) AS Drawn
    ,SUM(CASE WHEN Scored < Conceded THEN 1 ELSE 0 END) AS Lost
    ,SUM(results.Scored) AS [For]
    ,SUM(results.Conceded) AS [Against]
    ,SUM(results.Scored) - SUM(results.Conceded) AS GD
    ,SUM(CASE WHEN Scored > Conceded THEN 3 WHEN Scored = Conceded THEN 1 ELSE 0 END) as Points
 FROM results
GROUP BY results.Team)
SELECT
ROW_NUMBER()  OVER (ORDER BY Points DESC, GD DESC, [For] DESC) AS 'Position'
, RANK() OVER (ORDER BY Points DESC, GD DESC, [For] DESC) AS 'Ranked Position'
,* FROM league_table
ORDER BY Points DESC, GD DESC, [For] DESC
