--Overrides the default from the dbt_project.yml--
--Initially, we updated this to materialize as a view instead of the table setting in dbt_project.yml--
{{
    config(
        materialized='table'
    )
}}

--Using a ref function to call rename of customer_id from stg_customers.sql--
with customers as (

    select
        --Original dimension--
        --id as customer_id,

        --Dimension from ref--
        customer_id,
        first_name,
        last_name

    from {{ ref('stg_customers') }}
    --Original FROM source below--
    --from raw.jaffle_shop.customers

),

orders as (

    select
        order_id,
        --id as order_id,
        --Original dimension--
        --user_id as customer_id,

        --Dimension from staging--
        customer_id,
        order_date,
        status

    from {{ ref('stg_orders') }}
    --from raw.jaffle_shop.orders

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
