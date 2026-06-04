with customers as (

    select
        customer_id,
        first_name,
        last_name,
        number_of_orders
    from {{ ref('dim_customers') }}

),

ranked_customers as (

    select
        customer_id,
        first_name,
        last_name,
        number_of_orders as total_orders,
        rank() over (
            order by number_of_orders desc, customer_id
        ) as customer_rank
    from customers

)

select *
from ranked_customers
