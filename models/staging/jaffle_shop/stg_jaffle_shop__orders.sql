with 

source as (

    select 
    id as order_id,
    user_id as customer_id,
    order_date,
    status,
        _etl_loaded_at
     from {{ source('jaffle_shop', 'orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        order_date,
        status,
        _etl_loaded_at

    from source

)

select * from renamed