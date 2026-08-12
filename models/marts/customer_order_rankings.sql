with customer_order_counts as (

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

    from customer_order_counts

)

select *
from final
