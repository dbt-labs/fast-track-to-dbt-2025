select
    customer_id,
    number_of_orders,
    order_rank

from {{ ref('customer_order_rankings') }}

where number_of_orders < 0
    or order_rank < 1
