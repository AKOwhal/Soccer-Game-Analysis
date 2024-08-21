CREATE DATABASE SOCCER


---------3rd Highest Paid Player Name And Salary----------


SELECT p.FirstName, p.LastName, SQ.Amount
FROM
( 
SELECT s.playerId, s.amount, DENSE_RANK() OVER (ORDER BY S.amount DESC) AS Ranking
FROM Salary s
)
AS SQ
join player p ON p.playerid = sq.playerid
WHERE sq.Ranking = 3




WITH RankedSalary AS (
  SELECT 
    s.playerId, 
    s.amount, 
    DENSE_RANK() OVER (ORDER BY s.amount DESC) AS Ranking
  FROM 
    Salary s
)
SELECT 
  p.FirstName, 
  p.LastName, 
  Rs.Amount
FROM 
  RankedSalary Rs
  JOIN player p ON p.playerId = Rs.playerId
WHERE 
  Rs.Ranking = 3

 


 ------------3rd Lowest Paid Player Name And Salary-------


 SELECT p.FirstName, p.LastName, SQ.Amount
FROM
( 
SELECT s.playerId, s.amount, DENSE_RANK() OVER (ORDER BY S.amount ASC) AS Ranking
FROM Salary s
)
AS SQ
join player p ON p.playerid = sq.playerid
WHERE sq.Ranking = 3




WITH RankedSalary AS (
  SELECT 
    s.playerId, 
    s.amount, 
    DENSE_RANK() OVER (ORDER BY s.amount ASC) AS Ranking
  FROM 
    Salary s
)
SELECT 
  p.FirstName, 
  p.LastName, 
  Rs.Amount
FROM 
  RankedSalary Rs
  JOIN player p ON p.playerId = Rs.playerId
WHERE 
  Rs.Ranking = 3


 -------------- Which Position Scored Most Goals ---------------


SELECT TOP 1 
P.PositionName, SUM(S.Goals_Scored) AS TotalGoals
FROM Player AS PL
INNER JOIN Position AS P ON PL.PositionID = P.PositionID
INNER JOIN ScoredGoal AS S ON PL.PlayerID = S.PlayerID
GROUP BY P.PositionName
ORDER BY TotalGoals DESC




-------------- Which Player Never Scored Goal --------------


SELECT PL.PlayerID, PL.FirstName, PL.LastName
FROM Player AS PL
LEFT JOIN ScoredGoal AS S ON PL.PlayerID = S.PlayerID
WHERE S.PlayerID IS NULL



----------------Which Player Scored Most Goals---------------



SELECT TOP 1 PL.PlayerID, PL.FirstName, PL.LastName, SUM(S.Goals_Scored) AS TotalGoals
FROM Player AS PL
INNER JOIN ScoredGoal AS S ON PL.PlayerID = S.PlayerID
GROUP BY PL.PlayerID, PL.FirstName, PL.LastName
ORDER BY TotalGoals DESC




--------------- Which Player Score The Most Goal In Single Game------------



SELECT TOP 1 S.PlayerID, P.FirstName,P.LastName, S.goals_scored
FROM ScoredGoal AS S
INNER JOIN Player AS P ON S.PlayerID = P.PlayerID
ORDER BY S.goals_scored DESC



WITH RankedGoals AS (
  SELECT PlayerID, Goals_Scored,
  RANK() OVER (ORDER BY Goals_Scored DESC) AS GoalRank
  FROM ScoredGoal
)
SELECT RankedGoals.PlayerID, FirstName,LastName, Goals_Scored
FROM RankedGoals
INNER JOIN Player AS P ON RankedGoals.PlayerID = P.PlayerID
WHERE RankedGoals.GoalRank = 1




-------------- What Is The Average Minutes Score Goals As Per Player--------------


SELECT 
  SG.PlayerID, 
  AVG(SG.Minute) AS AvgMinutesPerGoal
FROM ScoredGoal SG
GROUP BY SG.PlayerID




---------------- Average Salary Per Goal By Position -----------


SELECT 
  PO.PositionName, 
  AVG(S.amount / SG.Goals_Scored) AS AvgSalaryPerGoal
FROM Player P
INNER JOIN Position PO ON P.PositionID = PO.PositionID
INNER JOIN Salary S ON P.PlayerID = S.PlayerID
INNER JOIN ScoredGoal SG ON P.PlayerID = SG.PlayerID
WHERE SG.goals_scored > 0
GROUP BY PO.PositionName




