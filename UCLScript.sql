-- create database UCL;
USE UCL;


## Part 1 Figure out if want to focus on 

-- # of distinct teams 
SELECT DISTINCT team FROM ucl_stats
ORDER BY team ASC;

SELECT team, year FROM ucl_stats
WHERE champions = 1;

-- # of champtionships per team 
SELECT team, SUM(champions) as Championships
FROM ucl_stats
where champions = 1 and year 
GROUP BY team
ORDER BY count(champions) DESC;


-- Win percentage of champions 
SELECT year, team, ((wins + .5*draws)/match_played) as win_percentage
FROM ucl_stats
where champions = 1
order by win_percentage desc;

-- Count losses when win
SELECT year, team, losts, match_played, (losts/match_played) as loss_percentage
from ucl_stats
where champions = 1
order by loss_percentage desc;

-- Goal differenetial when win
SELECT year, team, gd
FROM ucl_stats
where champions = 1
order by gd desc;

-- Group points when win
SELECT year, team, group_point
FROM ucl_stats
where champions = 1
order by group_point desc;

-- Avg group points when win (need to adjust to percentage of group stage wins cause group game # changed year to year
select AVG(group_point)
from ucl_stats
where champions = 1;

## SECOND TABLES ##

## UPDATING SEASONS COLUMN TO BE SAME FORMAT AS SEASONS COLUMN IN OTHER TABLE (for relationship in tableau)
## (this was done to only get results from > 1993 for future queries)
-- Remove hyphens from seasons
update ucl_league
set seasons = replace(seasons, '–', ' ');
-- Substring seasons to parts want
update ucl_league
set seasons = SUBSTRING(seasons, 1, 4) + 1;
-- Convert to int
ALTER TABLE ucl_league MODIFY seasons INT;
-- Delete data not included in other table
DELETE FROM ucl_league WHERE seasons < 1993;

-- Which league has the most ucls
SELECT winners_nation, count(seasons) as Championships
from ucl_league
where seasons > 1992
group by winners_nation
order by Championships DESC;

-- Best team in each league
SELECT winners_nation, winners_team, count(seasons) as Championships
from ucl_league
where seasons > 1992
group by winners_team, winners_nation
order by winners_nation, Championships DESC;

-- League with most unique teams winning
SELECT winners_nation, count(DISTINCT winners_team) as Unique_winners
from ucl_league
where seasons > 1992
group by winners_nation
order by Unique_winners DESC;
