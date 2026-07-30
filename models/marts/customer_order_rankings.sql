with order_counts as (

    select
        customer_id,
        count(order_id) as total_orders

    from {{ ref('fct_orders') }}

    group by 1

),

customer_order_rankings as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(order_counts.total_orders, 0) as total_orders

    from {{ ref('dim_customers') }} as customers

    left join order_counts using (customer_id)

),

final as (

    select
        *,
        row_number() over (
            order by total_orders desc, customer_id
        ) as customer_order_rank

    from customer_order_rankings

)

select *
from final
