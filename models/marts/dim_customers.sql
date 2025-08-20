{{
    config(
        materialized='table'
    )
}}

with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('stg_customers') }}

),

orders as (

    select
        order_id,
        customer_id,
        order_date,
        status

    from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),
-- customer_order_counts as (
--     select 
--         customer_id,
--         count(order_id) as total_orders
--     from orders
--     group by customer_id
-- ),

-- ranked_customers as (
--     select 
--         customer_id,
--         total_orders,
--         rank() over (order by total_orders desc) as customer_rank
--     from customer_order_counts
-- ),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
        -- ranked_customers.customer_rank

    from customers

    left join customer_orders using (customer_id)

)

select * 
from final
-- order by ranked_customers
