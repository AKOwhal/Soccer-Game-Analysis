# Soccer Game Analysis

## Problem Statement
This analysis helps to understand their top goal scorers, overall team performance, goal distribution, game moments, player contribution, player position analysis and game outcomes prediction & thus they can improve their team performance by identifying these area. It also lets them know the average players, star player & improve tactics to win games, & thus since by using this analysis they have identified problems, they can further work on factors responsible.





### Steps followed
- Step 1 : Dataset is a excel file.
- Step 2 : In excel file there are 4 tables which is Player, Position, Salary & ScoredGoal.
- Step 3 : Created Soccer database on ssms to import tables from excel file.
- Step 4 : Load data into SQL Server Management Studio (SSMS).
- Step 5 : It was observed that in none of the columns errors & empty values were present.
- Step 6 : Analysing the data to represent different KPI mentioned below,

  (a) Highest paid player & salary

  (b) Top goal scorers
  
  (c) Overall team performance
  
  (d) Goal distibution
  
  (e) Player contribution
  
  (f) Player position analyse

  (g) Avarage minutes per goal 
  
  (h) Most goals scored by player in single game
  
  (i) Average salary by position
  
  (j) Lowest salary
  
- Step 7 : write SQL queries to to find these KPI;

 
 To find third highest salary & player name using Subquery,
 
         SELECT p.FirstName, p.LastName, SQ.Amount
         FROM
         ( 
           SELECT s.playerId, s.amount, DENSE_RANK() OVER (ORDER BY S.amount DESC) AS Ranking
           FROM Salary s
         ) AS SQ
         join player p ON p.playerid = sq.playerid
         WHERE sq.Ranking = 3
 
 To find third highest salary & player name using CTE,
 
         WITH RankedSalary AS 
         (
         SELECT s.playerId, s.amount, DENSE_RANK() OVER (ORDER BY s.amount DESC) AS Ranking
         FROM Salary s
         )
         SELECT p.FirstName, p.LastName, Rs.Amount FROM RankedSalary Rs
         JOIN player p ON p.playerId = Rs.playerId
         WHERE  Rs.Ranking = 3
 
 Snap of 3rd highest salary and player
 
 ![3RD HIGH SAL](https://github.com/user-attachments/assets/ee1b3de6-f147-4b92-bf05-cc7405e4aa16)

![3rd high sal cte](https://github.com/user-attachments/assets/7b87707d-4878-4bc4-90b2-f9149cd5ec3d)

To find top goal scored by position,

         SELECT TOP 1 P.PositionName, SUM(S.Goals_Scored) AS TotalGoals
         FROM Player AS PL
         INNER JOIN Position AS P ON PL.PositionID = P.PositionID
         INNER JOIN ScoredGoal AS S ON PL.PlayerID = S.PlayerID
         GROUP BY P.PositionName
         ORDER BY TotalGoals DESC

Snap of top goal scored by poisition

![Most Goals Position](https://github.com/user-attachments/assets/eb34c86b-6d44-42da-b30f-47d0d84627b7)

 To find which player never scored goal,
        
         SELECT PL.PlayerID, PL.FirstName, PL.LastName FROM Player AS PL
         LEFT JOIN ScoredGoal AS S ON PL.PlayerID = S.PlayerID
         WHERE S.PlayerID IS NULL

Snap of which player never scored

![plyr nvr scored](https://github.com/user-attachments/assets/8c4919e7-5dc6-4e5e-9ac3-b2edc0bc5980)


 To find top goal scorrer player in all games,
 
     SELECT TOP 1 PL.PlayerID, PL.FirstName, PL.LastName, SUM(S.Goals_Scored)      AS TotalGoals
     FROM Player AS PL
     INNER JOIN ScoredGoal AS S ON PL.PlayerID = S.PlayerID
     GROUP BY PL.PlayerID, PL.FirstName, PL.LastName
     ORDER BY TotalGoals DESC

Snap of most goals scored player

![plyr score most goal](https://github.com/user-attachments/assets/a2386a41-ee24-4ace-afbb-b850ed0882e5)

To find top goal scorrer player in single game,
By Subquery

         SELECT TOP 1 S.PlayerID, P.FirstName,P.LastName, S.goals_scored
         FROM ScoredGoal AS S
         INNER JOIN Player AS P ON S.PlayerID = P.PlayerID
         ORDER BY S.goals_scored DESC

By CTE

         WITH RankedGoals AS (
         SELECT PlayerID, Goals_Scored, RANK() OVER (ORDER BY Goals_Scored DESC) AS GoalRank
         FROM ScoredGoal
         )
         SELECT RankedGoals.PlayerID, FirstName,LastName, Goals_Scored
         FROM RankedGoals
         INNER JOIN Player AS P ON RankedGoals.PlayerID = P.PlayerID
         WHERE RankedGoals.GoalRank = 1

Snap of top goals scorer player in single game

![most goals scored 1game](https://github.com/user-attachments/assets/f1139b4a-68be-4745-9633-3261a3c5d730)
![most goals scored 1game cte](https://github.com/user-attachments/assets/d717e0a0-9b3a-417e-ba76-53d6c5be5e3b)


To find average minutes to scored goals by per player,

         SELECT SG.PlayerID, AVG(SG.Minute) AS AvgMinutesPerGoal
         FROM ScoredGoal SG
         GROUP BY SG.PlayerID

Snap of average minutes to scored goals by per player

![Avg min per player](https://github.com/user-attachments/assets/010fe151-cd98-47b0-9826-4785ca5ed286)

To find average salary per goals by position,

         SELECT PO.PositionName, AVG(S.amount / SG.Goals_Scored) AS AvgSalaryPerGoal 
         FROM Player P
         INNER JOIN Position PO ON P.PositionID = PO.PositionID
         INNER JOIN Salary S ON P.PlayerID = S.PlayerID
         INNER JOIN ScoredGoal SG ON P.PlayerID = SG.PlayerID
         WHERE SG.goals_scored > 0
         GROUP BY PO.PositionName
    
Snap of average salary per goals by position

![aVG sal per goal by position](https://github.com/user-attachments/assets/eb1df4df-b9b3-4e1a-a634-26e77c6b329c)

To find lowest salary paid and player name,

         SELECT p.FirstName, p.LastName, SQ.Amount
         FROM
         ( 
         SELECT s.playerId, s.amount, DENSE_RANK() OVER (ORDER BY S.amount ASC) AS Ranking
         FROM Salary s
         ) AS SQ
         join player p ON p.playerid = sq.playerid
         WHERE sq.Ranking = 3

Snap of third lowest salary paid and player name

![3rd low sal](https://github.com/user-attachments/assets/7e3aae24-c0f7-4a63-8163-976a38d204d1)

# Insights
Following inferences can be drawn from the analysis;

### [1] Player Salaries
Arrie Barnfield, with a salary of 443.25. This suggests that Arrie is a top performer or has significant value to the team. & 3rd Lowest Paid Player Shelley Towersey, with a salary of 126.74. This could indicate that Shelley is either newer to the team, less experienced, or not as highly valued in terms of salary.

     Thus salary varies from experienced and either place in team.


### [2] Goal Scoring Patterns

A] Most Goals by Position: The Attacking Midfield position scored the most goals, with a total of 24. This indicates that the team's attacking strategy heavily relies on midfield players, highlighting the importance of this position in their overall performance.

B] Players Who Never Scored: There are six players who haven't scored any goals. This might indicate that these players are in more defensive roles, have had limited playtime, or are struggling in their offensive contributions.

C] Top Scorer: Ossie Albers is the leading goal scorer with 21 goals. Ossie is likely a key player for the team, possibly playing in a forward or attacking midfield role.

D] Most Goals in a Single Game: Enrico Trevaskiss scored 10 goals in a single game, which is an exceptional performance. This could be an outlier or indicate Enrico's potential in high-stakes situations.

     Basically Attacking Midfield Positioned players scored most goals and who never scored or less scored are in defensive roles

### [3] Game Performance
The average time to score goals varies significantly, with some games having goals scored within 1 minute and others taking up to 24 minutes.

      thus, The variance in these times suggests that the team's offensive
      consistency may need improvement, or it could reflect varying levels of
      opposition strength.
