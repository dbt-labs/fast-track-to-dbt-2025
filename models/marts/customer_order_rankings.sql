with order_counts as (

    select
        customer_id,
        count(order_id) as number_of_orders

    from {{ ref('fct_orders') }}

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(order_counts.number_of_orders, 0) as number_of_orders,
        rank() over (
            order by coalesce(order_counts.number_of_orders, 0) desc
        ) as customer_order_rank

    from {{ ref('dim_customers') }} as customers

    left join order_counts
        on customers.customer_id = order_counts.customer_id

)

select *
from final
order by customer_order_rank, customer_id
