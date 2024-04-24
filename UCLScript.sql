-- create database UCL;
USE UCL;


-- ## Part 1 Figure out focus of analysis

-- Distinct teams in dataset
SELECT DISTINCT team FROM ucl_stats
ORDER BY team ASC;


-- Champion from each year
SELECT team, year FROM ucl_stats
WHERE champions = 1;

-- # of championships per team 
SELECT team, SUM(champions) as Championships
FROM ucl_stats
WHERE champions = 1 
GROUP BY team
ORDER BY count(champions) DESC;


-- Win percentage of champions 
SELECT year, team, ((wins + .5*draws)/match_played) as win_percentage
FROM ucl_stats
WHERE champions = 1
ORDER BY win_percentage DESC;

-- Count losses when win
SELECT year, team, losts, match_played, (losts/match_played) as loss_percentage
FROM ucl_stats
WHERE champions = 1
ORDER BY loss_percentage DESC;

-- Goal differenetial when win
SELECT year, team, gd
FROM ucl_stats
WHERE champions = 1
ORDER BY gd DESC;

-- Group points when win
SELECT year, team, group_point
FROM ucl_stats
WHERE champions = 1
ORDER BY group_point DESC;

-- Avg group points when win (need to adjust to percentage of group stage wins cause group game # changed year to year
SELECT AVG(group_point)
FROM ucl_stats
WHERE champions = 1;

-- ## SECOND TABLES ##

-- ## UPDATING SEASONS COLUMN TO BE SAME FORMAT AS SEASONS COLUMN IN OTHER TABLE (for relationship in tableau)
-- ## (this was done to only get results from > 1993 for future queries)
-- Remove hyphens from seasons
UPDATE ucl_league
SET seasons = REPLACE(seasons, '–', ' ');
-- Substring seasons to parts want
UPDATE ucl_league
SET seasons = SUBSTRING(seasons, 1, 4) + 1;
-- Convert to int
ALTER TABLE ucl_league MODIFY seasons INT;
-- Delete data not included in other table
DELETE FROM ucl_league WHERE seasons < 1993;

-- Which league has the most ucls
SELECT winners_nation, count(*) as Championships
FROM ucl_league
WHERE seasons > 1992
GROUP BY winners_nation
ORDER BY Championships DESC;

-- Best team in each league
SELECT winners_nation, winners_team, count(*) AS Championships
FROM ucl_league
WHERE seasons > 1992
GROUP BY winners_nation, winners_team
ORDER BY winners_nation, Championships DESC;

-- League with most unique teams winning
SELECT winners_nation, count(DISTINCT winners_team) AS Unique_winners
FROM ucl_league
WHERE seasons > 1992
GROUP BY winners_nation
ORDER BY Unique_winners DESC;
