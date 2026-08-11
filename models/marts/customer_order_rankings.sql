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
        count(*) as total_orders

    from {{ ref('fct_orders') }}

    group by 1

),

customer_order_rankings as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(order_counts.total_orders, 0) as total_orders

    from customers

    left join order_counts using (customer_id)

)

select
    *,
    dense_rank() over (order by total_orders desc) as customer_order_rank
from customer_order_rankings
