select
    id as customer_id,
    first_name,
    last_name,
    concat(first_name, ' ', last_name) AS full_name
-- from raw.jaffle_shop.customers // rid of hard coded db.schema.table with shortcut
from {{ source('jaffle_shop', 'customers') }}