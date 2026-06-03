with 

source as (

    select * from {{ source('jaffle_shop', 'customers') }}

),

renamed as (

    select
        id customer_id,
        first_name,
        last_name

    from source

)

select * from renamed