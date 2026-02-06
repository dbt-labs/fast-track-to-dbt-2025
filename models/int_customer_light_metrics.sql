{{
   config(
       materialized='table',
       tags=['intermediate']
   )
}}

/*
   中間層: customers → int_customer_light_metrics → light_customer_analytics
   SAO デモ用: 単純なパススルー
*/

select
   customer_id,
   first_name,
   last_name,
   number_of_orders
from {{ ref('customers') }}
