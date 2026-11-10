with customers as (

    select *
    from {{ ref('dim_customers') }}

),

customer_order_counts as (

    select
        customer_id,
        count(order_id) as total_orders

    from {{ ref('fct_orders') }}

    group by customer_id

),

customer_totals as (

    select
        customers.*,
        coalesce(customer_order_counts.total_orders, 0) as total_orders

    from customers

    left join customer_order_counts using (customer_id)

),

final as (

    select
        customer_totals.*,
        row_number() over (order by total_orders desc) as order_rank  -- rank with no ties

    from customer_totals

)

select *
from final
