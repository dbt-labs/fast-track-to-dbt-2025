{{
    config(
        materialized='view'
    )
}}

with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

    select
        order_id,
        customer_id,
        order_date,
        status

    from {{ ref('stg_jaffle_shop__orders') }}

),

cancelled_orders as (

    select
        customer_id
    from orders
    where status = 'cancelled'

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name
    from customers
    inner join cancelled_orders using (customer_id)

)

select * 
from final