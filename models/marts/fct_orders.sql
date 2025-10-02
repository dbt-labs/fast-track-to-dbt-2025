with orders as  (
   
   select * from {{ ref('stg_orders') }}

),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final