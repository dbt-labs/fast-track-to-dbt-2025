with customers as (

    select *
    from {{ ref('dim_customers') }}

),

customer_orders as (

    select
        customer_id,
        count(order_id) as total_orders
    from {{ ref('fct_orders') }}
    group by customer_id

),

ranked_customers as (

    select
        customers.*,
        coalesce(customer_orders.total_orders, 0) as total_orders,
        rank() over (
            order by coalesce(customer_orders.total_orders, 0) desc
        ) as customer_order_rank
    from customers
    left join customer_orders
        on customers.customer_id = customer_orders.customer_id

)

select *
from ranked_customers
