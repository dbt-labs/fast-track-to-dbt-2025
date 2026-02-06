with
customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

joined as (
    select *
    from
        customers
    left join
        orders using (customer_id)
)

select * from joined