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

customer_order_counts as (

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
        coalesce(customer_order_counts.total_orders, 0) as total_orders,
        dense_rank() over (
            order by coalesce(customer_order_counts.total_orders, 0) desc
        ) as customer_order_rank

    from customers

    left join customer_order_counts using (customer_id)

)

select *
from final
order by customer_order_rank, customer_id
