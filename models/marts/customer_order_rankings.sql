with customer_order_counts as (

    select
        customer_id,
        count(order_id) as total_orders

    from {{ ref('fct_orders') }}

    group by 1

),

ranked_customers as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(customer_order_counts.total_orders, 0) as total_orders

    from {{ ref('dim_customers') }} as customers

    left join customer_order_counts using (customer_id)

)

select
    customer_id,
    first_name,
    last_name,
    total_orders,
    dense_rank() over (
        order by total_orders desc
    ) as customer_order_rank

from ranked_customers
