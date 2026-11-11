with customers as (

    select *
    from {{ ref('dim_customers') }}

),

customer_order_totals as (

    select
        customer_id,
        count(order_id) as total_orders

    from {{ ref('fct_orders') }}
    group by customer_id

),

customer_totals as (

    select
        customers.*,
        coalesce(customer_order_totals.total_orders, 0) as total_orders

    from customers
    left join customer_order_totals
        on customers.customer_id = customer_order_totals.customer_id

),

final as (

    select
        customer_totals.*,
        rank() over (order by total_orders desc) as order_rank

    from customer_totals

)

select *
from final
