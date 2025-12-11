with orders as  (
   
   select id as order_id,
        customer_id,
        order_date,
        status
   from {{ref("stg_orders")}}

),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final