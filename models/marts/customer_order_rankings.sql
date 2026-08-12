with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('dim_customers') }}

),

orders as (

    select
        order_id,
        customer_id

    from {{ ref('fct_orders') }}

),

customer_order_counts as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        count(orders.order_id) as number_of_orders

    from customers

    left join orders using (customer_id)

    group by 1, 2, 3

),

final as (

    select
        customer_id,
        first_name,
        last_name,
        number_of_orders,
        dense_rank() over (
            order by number_of_orders desc
        ) as customer_order_rank

    from customer_order_counts

)

select *
from final
order by customer_order_rank, customer_id
