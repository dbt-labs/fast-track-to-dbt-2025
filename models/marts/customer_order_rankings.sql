with customers as (

    select
        customer_id,
        first_name,
        last_name,
        number_of_orders as total_orders

    from {{ ref('dim_customers') }}

),

ranked_customers as (

    select
        customer_id,
        first_name,
        last_name,
        total_orders,
        rank() over (order by total_orders desc) as order_rank

    from customers

)

select
    customer_id,
    first_name,
    last_name,
    total_orders,
    order_rank,
    order_rank as customer_order_rank


from ranked_customers
