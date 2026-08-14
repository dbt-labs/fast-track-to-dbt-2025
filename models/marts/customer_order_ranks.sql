{{ config(materialized='table') }}

with customer_order_totals as (

    select
        customer_id,
        count(order_id) as total_orders

    from {{ ref('fct_orders') }}

    group by 1

),

customer_order_ranks as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(customer_order_totals.total_orders, 0) as total_orders

    from {{ ref('dim_customers') }} as customers

    left join customer_order_totals
        on customers.customer_id = customer_order_totals.customer_id

)

select
    customer_id,
    first_name,
    last_name,
    total_orders,
    dense_rank() over (order by total_orders desc) as customer_order_rank

from customer_order_ranks

order by total_orders desc, customer_id
