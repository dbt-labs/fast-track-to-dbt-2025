-- The fact-based and staging-based counts cover the same orders.
-- Counts must be non-negative and ranks start at one; tied ranks are valid.
select
    customer_id,
    number_of_orders,
    total_orders,
    order_rank
from {{ ref('customer_order_rankings') }}
where
    number_of_orders is null
    or total_orders < 0
    or total_orders <> number_of_orders
    or order_rank < 1
