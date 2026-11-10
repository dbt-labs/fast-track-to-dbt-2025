with customer_order_counts as (

    select
        customer_id,
        count(order_id) as total_orders

    from {{ ref('fct_orders') }}

    group by customer_id

),

customers_with_orders as (

    select
        customers.*,
        coalesce(customer_order_counts.total_orders, 0) as total_orders

    from {{ ref('dim_customers') }} as customers

    left join customer_order_counts
        on customers.customer_id = customer_order_counts.customer_id

)

select
    customers_with_orders.*,
    rank() over (order by total_orders desc) as order_rank

from customers_with_orders
