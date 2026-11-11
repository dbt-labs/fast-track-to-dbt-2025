-- Both order counts cover all statuses and must agree.
-- Dense ranks start at one; ties are valid and ranks are not unique.
select
    customer_id,
    number_of_orders,
    total_orders,
    order_count_rank
from {{ ref('customer_order_rankings') }}
where number_of_orders is null
    or number_of_orders < 0
    or total_orders < 0
    or total_orders <> number_of_orders
    or order_count_rank < 1
