-- Customers without orders have no order dates; customers with orders have
-- an ordered, non-null date range and a non-negative order count.
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
        and (
            first_order_date is not null
            or most_recent_order_date is not null
        )
    )
    or (
        number_of_orders > 0
        and (
            first_order_date is null
            or most_recent_order_date is null
            or first_order_date > most_recent_order_date
        )
    )
