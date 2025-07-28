SELECT 
    s.company_name AS shipper_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(o.shipped_date - o.required_date)::NUMERIC, 2) AS avg_delay_days,
    ROUND((COUNT(CASE WHEN o.shipped_date > o.required_date + INTERVAL '3 days' THEN 1 END) * 100.0 / COUNT(o.order_id)), 2) AS percent_over_3_days_delay,
    RANK() OVER (ORDER BY AVG(o.shipped_date - o.required_date)) AS delay_rank
FROM shippers1 s
LEFT JOIN orders1 o ON s.shipper_id = o.ship_via
WHERE o.shipped_date IS NOT NULL AND o.required_date IS NOT NULL
GROUP BY s.shipper_id, s.company_name
ORDER BY avg_delay_days;