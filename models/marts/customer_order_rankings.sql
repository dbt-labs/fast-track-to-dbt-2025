with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('dim_customers') }}

),

orders as (

    select
        order_id,
        customer_id

    from {{ ref('fct_orders') }}

),

customer_order_totals as (

    select
        customer_id,
        count(order_id) as total_orders

    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(customer_order_totals.total_orders, 0) as total_orders,
        dense_rank() over (
            order by coalesce(customer_order_totals.total_orders, 0) desc
        ) as customer_order_rank

    from customers

    left join customer_order_totals using (customer_id)

)

select *
from final
