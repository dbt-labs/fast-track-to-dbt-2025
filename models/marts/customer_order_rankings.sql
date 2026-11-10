with customers as (

    select
        customer_id,
        first_name,
        last_name,
        first_order_date,
        most_recent_order_date,
        number_of_orders

    from {{ ref('dim_customers') }}

),

customer_order_totals as (

    select
        customer_id,
        count(distinct order_id) as total_orders

    from {{ ref('fct_orders') }}

    group by customer_id

),

customer_totals as (

    select
        customers.*,
        coalesce(customer_order_totals.total_orders, 0) as total_orders

    from customers

    left join customer_order_totals
        on customers.customer_id = customer_order_totals.customer_id

)

select
    customer_totals.*,
    dense_rank() over (order by total_orders desc) as customer_order_rank

from customer_totals
