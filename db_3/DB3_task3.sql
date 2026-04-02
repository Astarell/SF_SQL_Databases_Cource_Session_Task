WITH hotels_category AS (
	SELECT h.id_hotel,
		   h.name,
		   CASE 
			   WHEN AVG(r.price) > 300 THEN 3 -- 'Дорогой'
			   WHEN AVG(r.price) > 175 THEN 2 -- 'Средний'
			   ELSE 1 -- 'Дешевый'
		   END AS hotel_category
	FROM hotel AS h
		JOIN room AS r ON h.id_hotel = r.id_hotel  
	GROUP BY h.id_hotel, h.name
),

customer_hotel_stats AS (
	SELECT b.id_customer,
       hc.id_hotel,
       hc.name AS hotel_name,
       hc.hotel_category
	FROM booking AS b
		JOIN room AS r ON b.id_room = r.id_room  
		JOIN hotels_category AS hc ON r.id_hotel = hc.id_hotel
),

customer_preferred_category AS (
    SELECT 
        id_customer,
        MAX(hotel_category) AS preferred_category
    FROM customer_hotel_stats
    GROUP BY id_customer
)

SELECT c.id_customer,
	   c.name,
	   CASE cpc.preferred_category
		   WHEN 3 THEN 'Дорогой'
		   WHEN 2 THEN 'Средний'
		   ELSE 'Дешевый'
	   END AS preferred_hotel_type,
	   ARRAY_TO_STRING(ARRAY(SELECT DISTINCT hotel_name FROM customer_hotel_stats WHERE id_customer = c.id_customer), ', ') AS visited_hotels
FROM customer AS c
	JOIN customer_preferred_category AS cpc ON c.id_customer = cpc.id_customer
GROUP BY c.id_customer, cpc.preferred_category
ORDER BY cpc.preferred_category;
