select
    customers.*,
    dense_rank() over (
        order by customers.number_of_orders desc
    ) as order_rank

from {{ ref('dim_customers') }} as customers
