-- Zero-order customers are valid, and tied customers may share a rank.
-- Counts cannot be negative and every rank must be at least one.
select
    customer_id,
    total_orders,
    order_rank
from {{ ref('customer_order_rankings') }}
where total_orders < 0
    or order_rank < 1
