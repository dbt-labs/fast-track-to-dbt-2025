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
        rank() over (
            order by number_of_orders desc
        ) as customer_rank
    from customers

)

select *
from ranked
