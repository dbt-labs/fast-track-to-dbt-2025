with orders as (

    select
        order_id,
        customer_id,
        order_date

    from {{ ref('fct_orders') }}

),

customer_orders as (

    select
        customer_id,
        count(*) as number_of_orders,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date

    from orders

    group by customer_id

),

final as (

    select
        customer_id,
        number_of_orders,
        first_order_date,
        most_recent_order_date,
        dense_rank() over (
            order by number_of_orders desc
        ) as customer_rank

    from customer_orders

)

select *
from final
