-- Counts must be nonnegative and agree across marts; dense ranks start at one.
select
    customer_id,
    number_of_orders,
    total_orders,
    order_rank
from {{ ref('customer_order_rankings') }}
where total_orders < 0
    or order_rank < 1
    or number_of_orders is null
    or total_orders <> number_of_orders
