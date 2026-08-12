with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('dim_customers') }}

),

customer_order_counts as (

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
        coalesce(customer_order_counts.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_order_counts using (customer_id)

)

select
    *,
    dense_rank() over (
        order by number_of_orders desc
    ) as customer_order_rank

from final
