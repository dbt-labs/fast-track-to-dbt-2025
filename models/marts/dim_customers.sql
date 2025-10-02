{{
    config(
        materialized='table'
    )
}}


with orders as (
    select 
        order_id,
        customer_id,
        order_date,
        status
    from {{ ref('stg_orders') }}
),

customer_order_counts as (
    select
        customer_id,
        count(order_id) as total_orders
    from orders
    group by customer_id
),

ranked_customers as (
    select
        customer_id,
        total_orders,
        rank() over (order by total_orders desc) as customer_rank
    from customer_order_counts
)

select 
    customer_id,
    total_orders,
    customer_rank
from ranked_customers