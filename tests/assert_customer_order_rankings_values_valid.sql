-- The two independent order summaries must agree, and ranks start at one.
select
    customer_id,
    number_of_orders,
    total_orders,
    order_rank
from {{ ref('customer_order_rankings') }}
where total_orders is null
    or number_of_orders is null
    or total_orders < 0
    or total_orders <> number_of_orders
    or order_rank is null
    or order_rank < 1
