{{
    config(
        materialized='table'
    )
}}

with customers as (

    select
        customer_id,
        first_name,
        last_name

    from {{ ref('stg_customers') }}

),

orders as (

    select
        order_id,
        customer_id,
        order_date,
        status

    from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from {{ ref('stg_orders') }}

    group by 1

),

ranked_customers as (

    select
        customer_id,
        number_of_orders,
        rank() over (order by number_of_orders desc) as customer_rank
    from customer_orders

),

final as (

    select
        c.customer_id,
        c.first_name,
        c.last_name,
        co.number_of_orders,
        rc.customer_rank
    from customers c
    inner join customer_orders co on c.customer_id = co.customer_id
    inner join ranked_customers rc on c.customer_id = rc.customer_id

)

select * 
from final