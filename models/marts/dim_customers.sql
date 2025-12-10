{{
    config(
        materialized='view'
    )
}}

with customers as (

    select
        customer_id,
        first_name,
        last_name

    --from raw.jaffle_shop.customers
    from {{ ref('stg_customers') }}

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    --from raw.jaffle_shop.orders
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

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * 
from final

with customer_order_counts as (
    select
        user_id as customer_id,
        count(id) as order_count
    from {{ source('jaffle_shop', 'orders') }}
    group by user_id
)

select
    customer_id,
    order_count,
    rank() over (order by order_count desc) as customer_rank
from customer_order_counts
order by customer_rank;