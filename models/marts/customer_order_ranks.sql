with customer_orders as (

    select
        customer_id,
        count(order_id) as number_of_orders

    from {{ ref('fct_orders') }}

    group by 1

),

final as (

    select
        customer_id,
        number_of_orders,
        row_number() over (
            order by number_of_orders desc, customer_id
        ) as order_rank

    from customer_orders

)

select *
from final
