WITH common_car_stats AS (
	SELECT AVG(res.position) AS average_position,
		c.name AS car_name,
		c.class AS car_class,
		COUNT(*) AS race_count
	FROM results AS res
		JOIN Cars AS c ON res.car = c.name
	GROUP BY c.name, c.class
),
min_by_car_class AS (
	SELECT car_class,
		   MIN(average_position) AS average_position
	FROM common_car_stats
	GROUP BY car_class
)

SELECT 
	car_stats.car_name,
	car_stats.car_class,
	car_stats.average_position,
	car_stats.race_count
FROM common_car_stats AS car_stats
	JOIN min_by_car_class AS min_stats 
		ON car_stats.average_position = min_stats.average_position
		AND car_stats.car_class = min_stats.car_class
ORDER BY car_stats.average_position