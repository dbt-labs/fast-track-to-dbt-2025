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

final as (

    select
        *,
        dense_rank() over (order by number_of_orders desc) as order_count_rank

    from customers

)

select *
from final
