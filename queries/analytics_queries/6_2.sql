SELECT 
    CASE 
        WHEN od.order_discount > 0 THEN 'With Discount'
        ELSE 'Without Discount'
    END AS discount_category,
    SUM(od.order_quantity) AS total_quantity_sold
FROM order_details1 od
GROUP BY discount_category;