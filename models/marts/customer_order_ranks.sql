with order_counts as (

    select
        customer_id,
        count(order_id) as total_orders

    from {{ ref('fct_orders') }}

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(order_counts.total_orders, 0) as total_orders,
        dense_rank() over (
            order by coalesce(order_counts.total_orders, 0) desc
        ) as customer_order_rank

    from {{ ref('dim_customers') }} as customers

    left join order_counts using (customer_id)

)

select *
from final
