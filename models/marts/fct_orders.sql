{{
    config(
        materialized='table'
    )
}}
with orders as  (
   
   select id as order_id,
        user_id as customer_id,
        order_date,
        status
   --from raw.jaffle_shop.orders
   {{ ref('stg_orders') }}

),

final as (

   select
       orders.*
   from orders
   
)

select * 
from final