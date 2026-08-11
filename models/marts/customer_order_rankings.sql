with customer_order_totals as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        count(orders.order_id) as total_orders

    from {{ ref('dim_customers') }} as customers

    left join {{ ref('fct_orders') }} as orders using (customer_id)

    group by 1, 2, 3

),

final as (

    select
        customer_id,
        first_name,
        last_name,
        total_orders,
        rank() over (order by total_orders desc) as customer_order_rank

    from customer_order_totals

)

select *
from final
order by customer_order_rank, customer_id
