with customers as (

    select *
    from {{ ref('dim_customers') }}

)

select
    customers.*,
    dense_rank() over (order by number_of_orders desc) as order_rank
from customers
