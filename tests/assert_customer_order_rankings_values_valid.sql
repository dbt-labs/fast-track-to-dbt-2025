-- Order counts may be zero; ranks start at one. Nulls are covered by the existing generic tests.
select
    customer_id,
    total_orders,
    order_rank
from {{ ref('customer_order_rankings') }}
where total_orders < 0
    or order_rank < 1
