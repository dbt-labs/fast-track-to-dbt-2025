--  adding a config setting here overrides what is in the yml file
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

    from {{ ref('stg_customers') }} -- ref is a function that allows you to reference a model name that is internal to this instance

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from {{ ref('stg_orders') }} -- can either "copy as ref" from the tables on the left or type __ref enter

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

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
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * 
from final
