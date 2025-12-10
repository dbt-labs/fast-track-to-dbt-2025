with orders as  (
   
   select --id as order_id,
        order_id,
        --user_id as customer_id,
        customer_id,
        order_date,
        status
   from {{ ref('stg_orders') }}    --raw.jaffle_shop.orders

),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final