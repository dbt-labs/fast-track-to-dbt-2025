with customer_order_dates as (
   select
       customer_id,
       first_order_date,
       most_recent_order_date
   from {{ ref('customers') }}
)

select
   customer_id,
   first_order_date,
   most_recent_order_date
from customer_order_dates
where first_order_date > most_recent_order_date
