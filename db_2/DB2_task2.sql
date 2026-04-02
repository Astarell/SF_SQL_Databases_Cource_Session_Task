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
)

SELECT car_name,
	   car_class,
	   average_position,
	   race_count,
	   car_country
FROM common_car_stats
ORDER BY average_position, car_name
LIMIT 1;