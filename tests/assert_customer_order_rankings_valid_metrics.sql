-- Both marts include all order statuses, so their customer order counts agree.
-- Order counts are nonnegative and dense ranks start at one.
select
    customer_id,
    number_of_orders,
    total_orders,
    order_rank
from {{ ref('customer_order_rankings') }}
where total_orders < 0
    or order_rank < 1
    or total_orders <> number_of_orders
