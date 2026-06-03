{{ config(
    materialized='view'
) }}

{{
    build_customer_order_dimension(
        customer_relation=ref('stg_jaffle_shop__customers'),
        order_relation=ref('stg_jaffle_shop__orders')
    )
}}
