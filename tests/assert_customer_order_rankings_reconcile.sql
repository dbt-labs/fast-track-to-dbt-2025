-- Reconcile customer coverage, distinct order totals, and dense ranks with
-- the customer dimension and order fact, including customers without orders.
with order_totals as (

    select
        customer_id,
        count(distinct order_id) as total_orders
    from {{ ref('fct_orders') }}
    group by customer_id

),

expected_totals as (

    select
        customers.customer_id,
        coalesce(order_totals.total_orders, 0) as total_orders
    from {{ ref('dim_customers') }} as customers
    left join order_totals
        on customers.customer_id = order_totals.customer_id

),

expected_rankings as (

    select
        customer_id,
        total_orders,
        dense_rank() over (order by total_orders desc) as order_rank
    from expected_totals

)

select
    coalesce(expected.customer_id, actual.customer_id) as customer_id,
    expected.total_orders as expected_total_orders,
    actual.total_orders as actual_total_orders,
    expected.order_rank as expected_order_rank,
    actual.order_rank as actual_order_rank
from expected_rankings as expected
full outer join {{ ref('customer_order_rankings') }} as actual
    on expected.customer_id = actual.customer_id
where expected.customer_id is null
    or actual.customer_id is null
    or actual.total_orders is distinct from expected.total_orders
    or actual.order_rank is distinct from expected.order_rank
