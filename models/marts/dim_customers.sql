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

    from {{ ref('stg_customers') }}

),

orders as (

    select
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
       


    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
       
       

    from customers

    left join customer_orders using (customer_id)

)

select * 
from final
