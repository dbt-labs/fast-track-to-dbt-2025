with customers as (

    select
        customer_id,
        number_of_orders

    from {{ ref('dim_customers') }}

),

ranked_customers as (

    select
        customer_id,
        number_of_orders,
        rank() over (order by number_of_orders desc) as order_count_rank

    from customers

)

select *
from ranked_customers
