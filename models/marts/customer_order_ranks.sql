with customer_order_counts as (

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
        coalesce(customer_order_counts.total_orders, 0) as total_orders,
        dense_rank() over (
            order by coalesce(customer_order_counts.total_orders, 0) desc
        ) as customer_order_rank

    from {{ ref('dim_customers') }} as customers

    left join customer_order_counts
        on customers.customer_id = customer_order_counts.customer_id

)

select *
from final
order by total_orders desc, customer_id
