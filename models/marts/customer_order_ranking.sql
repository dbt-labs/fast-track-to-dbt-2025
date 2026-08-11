{{ config(materialized='view') }}

with customers as (

    select
        customer_id,
        first_name,
        last_name,
        number_of_orders

    from {{ ref('dim_customers') }}

),

final as (

    select
        customer_id,
        first_name,
        last_name,
        number_of_orders,
        dense_rank() over (
            order by number_of_orders desc
        ) as customer_order_rank

    from customers

)

select *
from final
