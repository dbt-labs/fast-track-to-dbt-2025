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

    from {{ ref("stg_jaffle_shop__customers")}}

),

orders as (

    select
        order_id,
        customer_id,
        order_date,
        status

    from {{ref("stg_jaffle_shop__orders")}}

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

),

ranked_customers as (

    select
        *,
        row_number() over (order by number_of_orders desc) as customer_rank
    from final

)

select *
from ranked_customers
order by customer_rank