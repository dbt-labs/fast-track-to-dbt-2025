with 

source as (

    select * from {{ source('fifa', 'player') }}

),

renamed as (

    select
        id,
        player_first_name,
        player_middle_name,
        player_last_name,
        player_known_name,
        birth_date,
        weight,
        height,
        city,
        national_team_affiliation_id,
        affiliation_id

    from source

)

select * from renamed