-- Counts include zero-order customers; dense ranks always start at one.
select
    customer_id,
    total_orders,
    order_count_rank
from {{ ref('customer_order_rankings') }}
where total_orders < 0 or order_count_rank < 1
