-- Customers without orders must have null order dates. Customers with orders
-- must have both dates populated in chronological order and a nonnegative count.
select
    customer_id,
    number_of_orders,
    first_order_date,
    most_recent_order_date
from {{ ref('dim_customers') }}
where number_of_orders < 0
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
