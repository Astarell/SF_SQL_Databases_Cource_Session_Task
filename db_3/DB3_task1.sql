WITH hotels_by_customer AS (
SELECT b.id_customer,
	   h.id_hotel,
	   COUNT(r.id_room) AS booking_times,
	   h.name AS hotel_name
FROM booking AS b
	JOIN room AS r ON b.id_room = r.id_room
	JOIN hotel AS h ON h.id_hotel = r.id_hotel
GROUP BY b.id_customer, h.id_hotel
ORDER BY b.id_customer
),

customer_stats AS (
	SELECT hbc.id_customer,
	   SUM(hbc.booking_times) AS total_bookings,
	   STRING_AGG(DISTINCT hbc.hotel_name, ', ') AS hotels
	FROM hotels_by_customer AS hbc
	GROUP BY hbc.id_customer
	HAVING SUM(hbc.booking_times) > 2 AND COUNT(DISTINCT hbc.id_hotel) >= 2
)

SELECT c.name,
	   c.email,
	   c.phone,
	   cs.total_bookings,
	   cs.hotels,
	   ROUND(AVG(DATE_PART('day', b.check_out_date::TIMESTAMP - b.check_in_date::TIMESTAMP))::DECIMAL, 1) AS avg_duration
FROM customer_stats AS cs
	JOIN customer AS c ON cs.id_customer = c.id_customer 
	JOIN booking AS b ON b.id_customer = cs.id_customer
GROUP BY c.name, c.email, c.phone, cs.total_bookings, cs.hotels
ORDER BY total_bookings DESC;
