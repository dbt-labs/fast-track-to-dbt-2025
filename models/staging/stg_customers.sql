select
    id as customer_id,
    first_name,
    last_name

--use the 'source' macro because we're selecting from a raw source
from {{ source('jaffle_shop', 'customers') }}