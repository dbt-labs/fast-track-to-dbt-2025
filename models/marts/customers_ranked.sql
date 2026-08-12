with order_counts as (

    select
        customer_id,
        count(*) as total_orders

    from {{ ref('fct_orders') }}

    group by 1

),

customers_with_order_counts as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(order_counts.total_orders, 0) as total_orders

    from {{ ref('dim_customers') }} as customers

    left join order_counts
        on customers.customer_id = order_counts.customer_id

)

select
    customer_id,
    first_name,
    last_name,
    total_orders,
    dense_rank() over (order by total_orders desc) as customer_order_rank

from customers_with_order_counts
