with orders as (
    select 
        order_id,
        customer_id
    from {{ ref('stg_orders') }}
),

customer_order_counts as (
    select 
        customer_id,
        count(order_id) as total_orders
    from orders
    group by customer_id
),

ranked_customers as (
    select 
        customer_id,
        total_orders,
        rank() over (order by total_orders desc) as customer_rank
    from customer_order_counts
)

select 
    dim_customers.customer_id,
    ranked_customers.total_orders,
    ranked_customers.customer_rank
from 
    {{ ref('dim_customers') }} as dim_customers
inner join 
    ranked_customers
    on dim_customers.customer_id = ranked_customers.customer_id
order by 
    ranked_customers.customer_rank