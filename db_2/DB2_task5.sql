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

lowest_avg_position_cars AS (
	SELECT car_name,
		car_class,
		average_position,
		race_count,
		car_country,
		CASE WHEN average_position > 3.0 THEN 1 ELSE 0 END AS is_low_performance
	FROM common_car_stats
),

lowest_avg_position_cars_counter AS (
	SELECT car_class,
		COUNT(*) AS car_counter
	FROM lowest_avg_position_cars
	WHERE is_low_performance = 1
	GROUP BY car_class
),

class_total_races AS (
    SELECT 
        c.class,
        COUNT(*) AS total_races
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.class
)

-- Буду выводить те автомобили, у которых is_low_performance = 1 (по примеру под "всеми", как понял, подразумеваются все "автомобили с низкой средней позицией")
SELECT main.car_name,
	   main.car_class,
	   main.average_position,
	   main.race_count,
	   main.car_country, 
	   ctr.total_races,
	   lapcc.car_counter AS low_position_count
FROM lowest_avg_position_cars AS main
	JOIN lowest_avg_position_cars_counter AS lapcc ON main.car_class = lapcc.car_class
	JOIN class_total_races AS ctr ON main.car_class = ctr.class
WHERE main.is_low_performance = 1 
  AND lapcc.car_counter = (SELECT MAX(car_counter) FROM lowest_avg_position_cars_counter)
ORDER BY lapcc.car_counter;