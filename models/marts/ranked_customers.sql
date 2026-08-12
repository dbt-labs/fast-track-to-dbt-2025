with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('dim_customers') }}

),

customer_orders as (

    select
        customer_id,
        count(order_id) as number_of_orders

    from {{ ref('fct_orders') }}

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        dense_rank() over (
            order by coalesce(customer_orders.number_of_orders, 0) desc, customers.customer_id
        ) as customer_order_rank

    from customers

    left join customer_orders using (customer_id)

)

select *
from final
