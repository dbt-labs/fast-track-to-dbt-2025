-- Ranking totals must agree with the inherited all-status customer order count.
-- Ranks are positive; ties are allowed by the model's dense-rank definition.
select
    customer_id,
    number_of_orders,
    total_orders,
    order_rank
from {{ ref('customer_order_rankings') }}
where
    total_orders < 0
    or order_rank < 1
    or number_of_orders is null
    or total_orders <> number_of_orders
