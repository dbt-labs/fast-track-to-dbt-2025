with orders as  (
   
   select 
        id as order_id,
        user_id as customer_id,
        order_date,
        status
   from {{ ref('stg_jaffle_shop__orders') }}
),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final