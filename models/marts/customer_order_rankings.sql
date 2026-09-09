with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('dim_customers') }}

),

customer_order_counts as (

    select
        customer_id,
        count(order_id) as total_orders

    from {{ ref('fct_orders') }}

    group by 1

),

customer_orders as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(customer_order_counts.total_orders, 0) as total_orders

    from customers

    left join customer_order_counts using (customer_id)

),

ranked_customers as (

    select
        customer_id,
        first_name,
        last_name,
        total_orders,
        dense_rank() over (order by total_orders desc) as customer_rank

    from customer_orders

)

select
    customer_id,
    first_name,
    last_name,
    total_orders,
    customer_rank

from ranked_customers
