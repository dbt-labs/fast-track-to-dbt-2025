with customers as (

    select *
    from {{ ref('dim_customers') }}

),

order_counts as (

    select
        customer_id,
        count(*) as total_orders
    from {{ ref('fct_orders') }}
    group by customer_id

),

customer_orders as (

    select
        customers.*,
        coalesce(order_counts.total_orders, 0) as total_orders
    from customers
    left join order_counts
        on customers.customer_id = order_counts.customer_id

)

select
    customer_orders.*,
    dense_rank() over (order by total_orders desc) as order_rank
from customer_orders
