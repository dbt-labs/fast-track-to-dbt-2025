with orders as  (
   
   select order_id,
        customer_id,
        order_date,
        status
   from {{ ref('stg_orders') }}--raw.jaffle_shop.orders

),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final