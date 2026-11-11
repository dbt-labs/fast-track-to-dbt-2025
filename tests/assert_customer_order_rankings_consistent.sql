-- The independently calculated order total must agree with the customer
-- dimension, and ranks must be dense and descend by total orders.
with ranked_customers as (
    select
        customer_id,
        number_of_orders,
        total_orders,
        order_rank,
        dense_rank() over (order by total_orders desc) as expected_order_rank
    from {{ ref('customer_order_rankings') }}
)

select
    customer_id,
    number_of_orders,
    total_orders,
    order_rank,
    expected_order_rank
from ranked_customers
where number_of_orders is null
    or total_orders < 0
    or total_orders <> number_of_orders
    or order_rank <> expected_order_rank
