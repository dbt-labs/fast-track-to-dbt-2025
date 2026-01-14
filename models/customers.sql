with customers as (

    select 
        id as customer_id,
        first_name,
        last_name 
    from raw_jaffle_shop.customers
),
orders as (
    select 
        id as order_id,
        user_id as customer_id,
        order_date,
        status
    from raw.jaffle_shop.orders
),