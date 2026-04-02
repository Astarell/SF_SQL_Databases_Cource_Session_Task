WITH customer_stats AS (
	SELECT b.id_customer,
		   COUNT(r.id_room) AS total_bookings,
		   SUM(r.price) AS total_spent,
		   COUNT(DISTINCT h.name) AS unique_hotels
	FROM booking AS b
		JOIN room AS r ON b.id_room = r.id_room
		JOIN hotel AS h ON h.id_hotel = r.id_hotel
	GROUP BY b.id_customer
)

SELECT c.id_customer,
	   c.name,
	   cs.total_bookings,
	   cs.total_spent,
	   cs.unique_hotels
FROM customer_stats AS cs
	JOIN customer AS c ON cs.id_customer = c.id_customer
WHERE (cs.total_bookings > 2 AND cs.unique_hotels >= 2) AND cs.total_spent > 500
ORDER BY total_spent ASC;
