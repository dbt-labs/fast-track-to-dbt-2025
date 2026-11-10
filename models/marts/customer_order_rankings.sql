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

),

final as (

    select
        customer_totals.*,
        rank() over (order by total_orders desc) as order_count_rank
    from customer_totals

)

select *
from final
