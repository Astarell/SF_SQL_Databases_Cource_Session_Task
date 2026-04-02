WITH common_car_stats AS (
	SELECT c.name AS car_name,
		c.class AS car_class,
		AVG(res.position) AS average_position,
		COUNT(*) AS race_count,
		cl.country AS car_country
	FROM results AS res
		JOIN Cars AS c ON res.car = c.name
		JOIN Classes AS cl ON cl.class = c.class 
	GROUP BY c.name, c.class, cl.country
),

min_position_class_stats AS (
	SELECT car_class,
		AVG(average_position) AS min_average_position
	FROM common_car_stats
	GROUP BY car_class
)

SELECT car_stats.car_name,
	   car_stats.car_class,
	   car_stats.average_position,
	   car_stats.race_count,
	   car_stats.car_country,
	   (
	   		SELECT COUNT(c.*) 
	   		FROM Results AS r
	   			JOIN Cars AS c ON r.car = c.name
	   		WHERE c.class = car_stats.car_class
	   
	   ) AS total_races
FROM common_car_stats AS car_stats
	JOIN min_position_class_stats AS class_stats ON car_stats.car_class = class_stats.car_class
WHERE class_stats.min_average_position = (SELECT MIN(min_average_position) FROM min_position_class_stats)
