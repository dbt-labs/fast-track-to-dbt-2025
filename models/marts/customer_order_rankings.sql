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

customer_order_counts as (

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
        coalesce(customer_order_counts.total_orders, 0) as total_orders

    from customers

    left join customer_order_counts
        on customers.customer_id = customer_order_counts.customer_id

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
