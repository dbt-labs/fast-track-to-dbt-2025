-- Customer order counts must be non-negative, including zero for customers without orders.
select
    customer_id,
    number_of_orders
from {{ ref('dim_customers') }}
where number_of_orders < 0
