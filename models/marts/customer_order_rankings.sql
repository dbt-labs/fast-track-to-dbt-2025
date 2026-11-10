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

customer_totals as (

    select
        customers.*,
        coalesce(customer_orders.total_orders, 0) as total_orders

    from customers
    left join customer_orders
        on customers.customer_id = customer_orders.customer_id

),

ranked_customers as (

    select
        customer_totals.*,
        dense_rank() over (order by total_orders desc) as order_rank

    from customer_totals

)

select *
from ranked_customers
