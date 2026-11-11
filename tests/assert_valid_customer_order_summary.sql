-- Counts and date summaries must agree, including customers with no orders.
-- Investigate the customer's source orders when this test returns rows.
select
    customer_id,
    number_of_orders,
    first_order_date,
    most_recent_order_date
from {{ ref('dim_customers') }}
where
    number_of_orders < 0
    or (
        number_of_orders = 0
        and (first_order_date is not null or most_recent_order_date is not null)
    )
    or (
        number_of_orders > 0
        and (
            first_order_date is null
            or most_recent_order_date is null
            or first_order_date > most_recent_order_date
        )
    )
