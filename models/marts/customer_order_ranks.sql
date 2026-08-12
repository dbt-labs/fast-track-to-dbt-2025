with customer_order_totals as (

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
        coalesce(customer_order_totals.total_orders, 0) as total_orders,
        row_number() over (
            order by
                coalesce(customer_order_totals.total_orders, 0) desc,
                customers.customer_id
        ) as customer_order_rank

    from {{ ref('dim_customers') }} as customers

    left join customer_order_totals using (customer_id)

)

select *
from final
