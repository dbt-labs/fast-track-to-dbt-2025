-- Reconcile customer-facing summaries against the orders fact.
-- Zero-order customers must have zero counts and null order dates.
with order_summary as (

    select
        customer_id,
        count(*) as expected_orders,
        min(order_date) as expected_first_order_date,
        max(order_date) as expected_most_recent_order_date
    from {{ ref('fct_orders') }}
    group by customer_id

),

validation as (

    select
        customers.customer_id,
        customers.number_of_orders,
        customers.first_order_date,
        customers.most_recent_order_date,
        rankings.total_orders,
        rankings.order_rank,
        coalesce(order_summary.expected_orders, 0) as expected_orders,
        order_summary.expected_first_order_date,
        order_summary.expected_most_recent_order_date,
        rankings.customer_id as ranking_customer_id
    from {{ ref('dim_customers') }} as customers
    left join order_summary
        on customers.customer_id = order_summary.customer_id
    left join {{ ref('customer_order_rankings') }} as rankings
        on customers.customer_id = rankings.customer_id

)

select *
from validation
where number_of_orders is distinct from expected_orders
    or first_order_date is distinct from expected_first_order_date
    or most_recent_order_date is distinct from expected_most_recent_order_date
    or total_orders is distinct from expected_orders
    or ranking_customer_id is null
    or order_rank is null
    or order_rank < 1
