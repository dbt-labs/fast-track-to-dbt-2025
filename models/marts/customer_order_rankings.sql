with customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date

    from {{ ref('dim_customers') }}

),

customer_order_counts as (

    select
        customer_id,
        count(order_id) as total_number_of_orders

    from {{ ref('fct_orders') }}

    group by 1

),

customer_orders as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.first_order_date,
        customers.most_recent_order_date,
        coalesce(customer_order_counts.total_number_of_orders, 0) as total_number_of_orders

    from customers

    left join customer_order_counts using (customer_id)

),

final as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        total_number_of_orders,
        dense_rank() over (
            order by total_number_of_orders desc
        ) as customer_order_rank

    from customer_orders

)

select *
from final
