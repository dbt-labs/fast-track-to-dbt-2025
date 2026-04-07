with 

source as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

),

renamed as (

    select
        id as customer_id
        first_name,
        last_name

    from source

)

select * from renamed