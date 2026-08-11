with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('dim_customers') }}

),

order_counts as (

    select
        customer_id,
        count(order_id) as total_number_of_orders

    from {{ ref('fct_orders') }}

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(order_counts.total_number_of_orders, 0) as total_number_of_orders,
        rank() over (
            order by coalesce(order_counts.total_number_of_orders, 0) desc
        ) as customer_order_rank

    from customers

    left join order_counts using (customer_id)

)

select *
from final
order by customer_order_rank, customer_id
