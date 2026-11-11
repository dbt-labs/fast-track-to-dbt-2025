with customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        number_of_orders

    from {{ ref('dim_customers') }}

),

ranked as (

    select
        rank() over (order by number_of_orders desc) as order_rank,
        customer_id,
        first_name,
        last_name,
        number_of_orders,
        first_order_date,
        most_recent_order_date

    from {{ ref('dim_customers') }}

)

select *
from ranked
