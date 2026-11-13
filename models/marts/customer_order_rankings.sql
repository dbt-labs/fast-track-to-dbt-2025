with customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date

    from {{ ref('dim_customers') }}

),

customer_orders as (

    select
        customer_id,
        count(order_id) as number_of_orders

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
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select
    customer_id,
    first_name,
    last_name,
    first_order_date,
    most_recent_order_date,
    number_of_orders,
    rank() over (order by number_of_orders desc) as order_rank

from customer_totals
