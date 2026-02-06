{{
   config(
       materialized='table',
       tags=['light', 'analytics']
   )
}}

/*
   軽量な顧客分析モデル
   上流: int_light_metrics (中間層)
   SAO デモ用: 上流変更で毎回ビルドされる
*/

select
   customer_id,
   first_name,
   last_name,
   number_of_orders,
   case
       when number_of_orders >= 3 then 'loyal'
       when number_of_orders >= 1 then 'regular'
       else 'new'
   end as customer_segment,
   current_timestamp as processed_at
from {{ ref('int_customer_light_metrics') }}
