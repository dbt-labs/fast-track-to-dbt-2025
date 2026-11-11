-- Failing rows identify missing/extra customers or counts that differ from fct_orders.
-- Investigate the customer_id join and any order filtering when this test fails.
with expected_totals as (

    select
        customers.customer_id,
        count(orders.order_id) as total_orders

    from {{ ref('dim_customers') }} as customers

    left join {{ ref('fct_orders') }} as orders
        on customers.customer_id = orders.customer_id

    group by customers.customer_id

),

actual as (

    select
        customer_id,
        total_orders

    from {{ ref('customer_order_rankings') }}

)

select
    coalesce(expected_totals.customer_id, actual.customer_id) as customer_id,
    expected_totals.total_orders as expected_total_orders,
    actual.total_orders as actual_total_orders

from expected_totals

full outer join actual
    on expected_totals.customer_id = actual.customer_id

where expected_totals.customer_id is null
    or actual.customer_id is null
    or actual.total_orders is null
    or expected_totals.total_orders <> actual.total_orders
