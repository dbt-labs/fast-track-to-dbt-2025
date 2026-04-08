with orders as  (
   
   select order_id,
        customer_id,
        order_date,
        status
   --from raw.jaffle_shop.orders
   from {{ ref('stg_jaffle_shop__orders') }}

),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final