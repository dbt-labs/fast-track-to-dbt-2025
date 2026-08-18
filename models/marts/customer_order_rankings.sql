with customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date

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

    group by customer_id

),

customers_with_order_counts as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.first_order_date,
        customers.most_recent_order_date,
        coalesce(customer_order_counts.total_orders, 0) as total_orders

    from customers

    left join customer_order_counts using (customer_id)

),

ranked_customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        total_orders,
        rank() over (order by total_orders desc) as customer_order_rank

    from customers_with_order_counts

)

select
    customer_id,
    first_name,
    last_name,
    first_order_date,
    most_recent_order_date,
    total_orders,
    customer_order_rank

from ranked_customers
