with 

source as (

    select * from {{ source('jaffle_shop', 'customers') }}

),

renamed as (

    select
        id as customer_id, -- we will remove stg_customers file and it will produe error as dim is dependent on that file
        first_name,
        last_name

    from source

)

select * from renamed