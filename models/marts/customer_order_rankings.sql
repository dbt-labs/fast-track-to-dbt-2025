with customers as (

    select
        customer_id,
        first_name,
        last_name

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
        coalesce(customer_orders.total_orders, 0) as total_orders

    from customers

    left join customer_orders
        on customers.customer_id = customer_orders.customer_id

),

final as (

    select
        customer_id,
        first_name,
        last_name,
        total_orders,
        dense_rank() over (order by total_orders desc) as order_rank

    from customer_totals

)

select *
from final
