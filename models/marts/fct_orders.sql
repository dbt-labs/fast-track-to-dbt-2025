with orders as  (
   
        order_id,
        user_id as customer_id,
        order_date,
        status
   from {{ ref('stg_customers') }}

),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final