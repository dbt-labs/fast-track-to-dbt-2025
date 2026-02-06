{{
    config(
        materialized='table'
    )   
}}

WITH
    customers AS (
        SELECT
            customer_id,
            first_name,
            last_name
        FROM
            {{ ref('stg_customers') }}
    ),
    orders AS (
        SELECT
            order_id,
            customer_id,
            order_date,
            status
        FROM
            {{ ref('stg_orders') }}
    )

SELECT
    o.customer_id,
    c.first_name,
    c.last_name,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS most_recent_order_date,
    COUNT(o.order_id) AS number_of_orders
FROM
    orders o
LEFT JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY 1, 2, 3