with orders as  (
   
   select order_id,
        customer_id,
        order_date,
        status
   from {{ ref('stg_orders') }}

),

final as (

   select
       orders.*
   from {{ ref('stg_orders') }}
   
)

select * 
from final