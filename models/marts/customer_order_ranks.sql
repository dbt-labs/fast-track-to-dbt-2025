with customer_order_counts as (

    select
        customer_id,
        number_of_orders

    from {{ ref('dim_customers') }}

),

final as (

    select
        customer_id,
        number_of_orders,
        rank() over (
            order by number_of_orders desc, customer_id
        ) as customer_order_rank

    from customer_order_counts

)

select *
from final
