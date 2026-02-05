{{
    config(
        materialized='view'
    )
}}

with
    customers as (
        select customer_id, first_name, last_name from {{ ref("stg_jaffle_shop__customers") }}
    ),
    customer_orders as (
        select
            customer_id,
            count(order_id) as number_of_orders
        from {{ ref("fct_orders") }}
        group by customer_id
    ),
    final as (
        select
            customers.customer_id,
            customers.first_name,
            customers.last_name,
            coalesce(customer_orders.number_of_orders, 0) as number_of_orders
        from customers
        left join customer_orders using (customer_id)
    ),
    ranked_customers as (
        select
            final.customer_id,
            final.first_name,
            final.last_name,
            final.number_of_orders,
            rank() over (order by final.number_of_orders desc) as customer_rank
        from final
    )
select *
from ranked_customers