with orders as (

    select
        order_id,
        customer_id,
        order_date,
        status

    from {{ ref('stg_orders') }}

),

customer_order_ranks as (

    select
        customer_id,
        order_rank

    from {{ ref('customer_order_ranks') }}

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        customer_order_ranks.order_rank

    from orders

    left join customer_order_ranks using (customer_id)

)

select *
from final
