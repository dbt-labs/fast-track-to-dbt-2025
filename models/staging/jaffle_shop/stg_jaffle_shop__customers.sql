with 

source as (

select
    id as customer_id,
    first_name,
    last_name 
    
    from {{ source('jaffle_shop', 'customers') }}

),

renamed as (

    select
        customer_id,
        first_name,
        last_name

    from source

)

select * from renamed