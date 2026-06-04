{{
    config(
        materialized='table'
    )
}}

with customers as (

    select *
    from {{ ref('dim_customers') }}

),

ranked as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        number_of_orders,
        dense_rank() over (
            order by number_of_orders desc
        ) as customer_order_rank


    from customers

)

select *
from ranked
