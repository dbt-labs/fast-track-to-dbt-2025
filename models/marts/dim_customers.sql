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

    --from raw.jaffle_shop.customers
    from {{ ref('stg_customers') }}

),

orders as (

    select
        order_id,
        customer_id,
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

ranked_customers as (

    select
        customer_id,
        number_of_orders,
        rank() over (order by number_of_orders desc) as customer_rank
    from customer_orders

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        ranked_customers.customer_rank

    from customers

    left join customer_orders using (customer_id)
    left join ranked_customers using (customer_id)

)

select * 
from final