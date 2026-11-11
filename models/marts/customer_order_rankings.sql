{{ config(materialized="view") }}

with order_counts as (

    select
        customer_id,
        count(*) as order_count
    from {{ ref('fct_orders') }}
    group by customer_id

),

customers_with_order_counts as (

    select
        customers.*,
        coalesce(order_counts.order_count, 0) as order_count
    from {{ ref('dim_customers') }} as customers
    left join order_counts
        on customers.customer_id = order_counts.customer_id

)

select
    customers_with_order_counts.*,
    dense_rank() over (order by order_count desc) as order_count_rank
from customers_with_order_counts
