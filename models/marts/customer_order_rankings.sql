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

final as (

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
from final
