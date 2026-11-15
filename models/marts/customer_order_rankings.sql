with customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        number_of_orders

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
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.first_order_date,
        customers.most_recent_order_date,
        customers.number_of_orders,
        coalesce(customer_orders.total_orders, 0) as total_orders

    from customers

    left join customer_orders
        on customers.customer_id = customer_orders.customer_id

)

select
    customer_id,
    first_name,
    last_name,
    first_order_date,
    most_recent_order_date,
    number_of_orders,
    total_orders,
    dense_rank() over (order by total_orders desc) as customer_rank

from customer_totals
