select
    id as order_id,
    customer_id,
    order_date,
    status

--from raw.jaffle_shop.orders
from {{ source('jaffle_shop', 'customers') }}