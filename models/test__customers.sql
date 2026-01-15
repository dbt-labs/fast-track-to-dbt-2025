with customer_order_dates as (
   select
       customer_id,
       first_order_date,
       most_recent_order_date
   from {{ ref('customers') }}
   --from dbt_learn.dbt_workshop_MIki_a60069.customers
)
 
select
   customer_id,
   first_order_date,
   most_recent_order_date
from customer_order_dates
where first_order_date > most_recent_order_date