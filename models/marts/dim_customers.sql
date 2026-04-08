{{
    config(
        materialized='view'
    )
}}


    select
        id,
        first_name,
        last_name

    --from raw.jaffle_shop.customers
    from {{ ref('stg_jaffle_shop_customers') }}