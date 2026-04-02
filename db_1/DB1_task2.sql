SELECT 
	v.maker,
	v.model,
	c.horsepower,
	c.engine_capacity,
	v.type AS vehicle_type
FROM vehicle AS v
	JOIN car AS c ON v.model = c.model
WHERE c.horsepower > 150 
	AND c.engine_capacity < 3
	AND c.price < 35000
UNION
SELECT 
	v.maker,
	v.model,
	m.horsepower,
	m.engine_capacity,
	v.type AS vehicle_type
FROM vehicle AS v
	JOIN motorcycle AS m ON v.model = m.model
WHERE m.horsepower > 150
	AND m.engine_capacity < 1.5
	AND m.price < 20000
UNION
SELECT 
	v.maker,
	v.model,
	NULL AS horsepower,
	NULL AS engine_capacity,
	v.type AS vehicle_type
FROM vehicle AS v
	JOIN bicycle AS b ON v.model = b.model
WHERE b.gear_count > 18
	AND b.price < 4000
ORDER BY horsepower DESC NULLS LAST

