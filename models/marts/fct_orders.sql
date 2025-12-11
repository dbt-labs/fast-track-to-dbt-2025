with orders as  (
   
   select order_id,
         customer_id,
        order_date,
        status
  -- from raw.jaffle_shop.orders
  from {{ ref('stg_orders') }}

),
--lmao, it ain't final though, right?
final as (

   select
       orders.*
   from orders
   
)

select * 
from final