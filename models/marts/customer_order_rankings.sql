with customer_orders as (

    select
        customer_id,
        count(*) as total_orders
    from {{ ref('fct_orders') }}
    group by customer_id

),

final as (

    select
        customer_id,
        total_orders,
        dense_rank() over (order by total_orders desc) as customer_order_rank
    from customer_orders

)

select *
from final
