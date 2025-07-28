SELECT 
    c.customer_id,
    c.company_name,
    ROUND(SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                   THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                   ELSE 0 END)::numeric, 2) AS total_1996,
    ROUND(SUM(CASE WHEN o97.order_date >= '1997-01-01' AND o97.order_date < '1998-01-01' 
                   THEN od97.order_price * od97.order_quantity * (1 - od97.order_discount) 
                   ELSE 0 END)::numeric, 2) AS total_1997,
    COALESCE(
        CASE 
            WHEN SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                          THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                          ELSE 0 END) = 0 THEN NULL
            ELSE ROUND(((SUM(CASE WHEN o97.order_date >= '1997-01-01' AND o97.order_date < '1998-01-01' 
                                 THEN od97.order_price * od97.order_quantity * (1 - od97.order_discount) 
                                 ELSE 0 END) - 
                         SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                                  THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                                  ELSE 0 END)) * 100.0 / 
                        SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                                 THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                                 ELSE 0 END))::numeric, 2)
        END::text,
        'Not Defined'
    ) AS percent_change,
    CASE 
        WHEN SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                      THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                      ELSE 0 END) = 0 THEN 'Stable'
        WHEN ((SUM(CASE WHEN o97.order_date >= '1997-01-01' AND o97.order_date < '1998-01-01' 
                        THEN od97.order_price * od97.order_quantity * (1 - od97.order_discount) 
                        ELSE 0 END) - 
               SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                        THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                        ELSE 0 END)) * 100.0 / 
              SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                       THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                       ELSE 0 END)) > 30 THEN 'Growing'
        WHEN ((SUM(CASE WHEN o97.order_date >= '1997-01-01' AND o97.order_date < '1998-01-01' 
                        THEN od97.order_price * od97.order_quantity * (1 - od97.order_discount) 
                        ELSE 0 END) - 
               SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                        THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                        ELSE 0 END)) * 100.0 / 
              SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                       THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                       ELSE 0 END)) < -30 THEN 'Declining'
        ELSE 'Stable'
    END AS status
FROM customers1 c
LEFT JOIN orders1 o96 ON c.customer_id = o96.customer_id 
    AND o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01'
LEFT JOIN order_details1 od96 ON o96.order_id = od96.order_id
LEFT JOIN orders1 o97 ON c.customer_id = o97.customer_id 
    AND o97.order_date >= '1997-01-01' AND o97.order_date < '1998-01-01'
LEFT JOIN order_details1 od97 ON o97.order_id = od97.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY 
    CASE 
        WHEN SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                      THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                      ELSE 0 END) = 0 THEN NULL
        ELSE ROUND(((SUM(CASE WHEN o97.order_date >= '1997-01-01' AND o97.order_date < '1998-01-01' 
                             THEN od97.order_price * od97.order_quantity * (1 - od97.order_discount) 
                             ELSE 0 END) - 
                     SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                              THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                              ELSE 0 END)) * 100.0 / 
                    SUM(CASE WHEN o96.order_date >= '1996-01-01' AND o96.order_date < '1997-01-01' 
                             THEN od96.order_price * od96.order_quantity * (1 - od96.order_discount) 
                             ELSE 0 END))::numeric, 2)
    END;