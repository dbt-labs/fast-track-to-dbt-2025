with customers as (
    select * from {{ ref('stg_customers') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date
    from orders
    group by customer_id
),
validation as (
    select
        customer_id,
        first_order_date,
        most_recent_order_date
    from customer_orders
    where most_recent_order_date < first_order_date
)
select * from validation