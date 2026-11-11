with customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        number_of_orders,
        dense_rank() over (
            order by number_of_orders desc
        ) as customer_rank

    from {{ ref('dim_customers') }}

),

orders as (

    select
        order_id,
        customer_id,
        order_date,
        status,
        row_number() over (
            partition by customer_id
            order by order_date asc nulls last, order_id asc
        ) as customer_order_number

    from {{ ref('stg_orders') }}

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        customers.first_name,
        customers.last_name,
        orders.order_date,
        orders.status,
        customers.first_order_date,
        customers.most_recent_order_date,
        customers.number_of_orders,
        customers.customer_rank,
        orders.customer_order_number

    from orders
    left join customers
        on orders.customer_id = customers.customer_id

)

select *
from final
