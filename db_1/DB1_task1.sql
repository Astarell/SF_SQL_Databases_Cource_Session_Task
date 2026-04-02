SELECT 
	v.maker,
	v.model
FROM vehicle AS v
	JOIN motorcycle AS m ON v.model = m.model
WHERE m.horsepower > 150 
	AND m.price < 20000
	AND m.type = 'Sport'
ORDER BY m.horsepower DESC