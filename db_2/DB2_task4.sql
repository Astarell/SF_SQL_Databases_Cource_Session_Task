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

avg_position_by_class AS (
	SELECT car_class,
		   AVG(average_position) AS class_avg_position
	FROM common_car_stats
	GROUP BY car_class
	HAVING COUNT(car_name) >= 2 -- автомобилей в классе должно быть минимум два, чтобы выбрать один из них
)

SELECT car_stats.car_name,
	   car_stats.car_class,
	   car_stats.average_position,
	   car_stats.race_count,
	   car_stats.car_country
FROM common_car_stats AS car_stats
	JOIN avg_position_by_class AS class_stats ON car_stats.car_class = class_stats.car_class
WHERE car_stats.average_position < class_stats.class_avg_position
ORDER BY car_stats.car_class, car_stats.average_position;
