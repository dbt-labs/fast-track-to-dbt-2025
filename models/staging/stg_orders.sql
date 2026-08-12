select
    id,
    user_id,
    order_date,
    status

from {{ source('jaffle_shop', 'orders') }}