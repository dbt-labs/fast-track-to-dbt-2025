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

order_totals as (

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
        coalesce(order_totals.total_orders, 0) as total_orders

    from customers

    left join order_totals
        on customers.customer_id = order_totals.customer_id

),

final as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        number_of_orders,
        total_orders,
        rank() over (order by total_orders desc) as order_rank

    from customer_totals

)

select *
from final
