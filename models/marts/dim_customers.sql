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

    from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

    select
        order_id,
        customer_id,
        order_date,
        status

    from {{ ref('stg_jaffle_shop__orders') }}

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

ranked_customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        coalesce(number_of_orders, 0) as number_of_orders,
        row_number() over (order by number_of_orders desc) as customer_rank

    from customer_orders
    join customers using (customer_id)

)

select *
from ranked_customers
order by customer_rank