-- 3 написать запрос суммы очков с группировкой и сортировкой по годам
SELECT  year_game, SUM(points)
FROM public.statistic
GROUP BY year_game
ORDER BY year_game;

-- 4 написать cte показывающее тоже самое
WITH cte AS (
	SELECT year_game, SUM(points) points
	FROM statistic
	GROUP BY year_game
	ORDER BY year_game
) 
SELECT  year_game, points
FROM cte;

-- 5 используя функцию LAG вывести кол-во очков по всем игрокам за текущий код и за предыдущий.
WITH cte AS (
	SELECT year_game, SUM(points) points
	FROM statistic
	GROUP BY year_game
	ORDER BY year_game
) 
SELECT  year_game, 
	points,
	LAG(points,1) OVER (ORDER BY year_game) previous_year_points
FROM cte;
