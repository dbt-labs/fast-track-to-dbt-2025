with orders as  (
   
   select order_id,
        customer_id,
        order_date,
        status
   FROM {{ ref('stg_orders') }}

),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final