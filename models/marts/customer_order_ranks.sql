with customer_orders as (

    select
        customer_id,
        first_name,
        last_name,
        number_of_orders

    from {{ ref('dim_customers') }}

),

final as (

    select
        customer_id,
        first_name,
        last_name,
        number_of_orders,
        row_number() over (
            order by number_of_orders desc, customer_id
        ) as order_rank

    from customer_orders

)

select *
from final
