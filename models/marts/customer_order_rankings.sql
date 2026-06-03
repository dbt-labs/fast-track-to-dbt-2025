{{
    config(
        materialized='view'
    )
}}

with customer_rankings as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        number_of_orders,
        rank() over (order by number_of_orders desc) as customer_order_rank
    from {{ ref('dim_customers') }}

)

select *
from customer_rankings
