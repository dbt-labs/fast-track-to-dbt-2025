-- Counts computed from fct_orders must agree with the dimension's lifetime
-- counts. Dense ranks start at one; tied customers may share a rank.
select
    customer_id,
    total_orders,
    number_of_orders,
    order_rank
from {{ ref('customer_order_rankings') }}
where total_orders < 0
    or order_rank < 1
    or number_of_orders is null
    or total_orders <> number_of_orders
