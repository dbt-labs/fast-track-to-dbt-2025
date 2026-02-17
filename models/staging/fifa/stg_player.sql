with 

source as (

    select * from {{ source('fifa', 'player') }}

),

renamed as (

    select
        id as player_id,
        player_first_name,
        player_middle_name,
        player_last_name,
        player_known_name,
        concat(player_first_name,' ', player_last_name) as player_name,
        birth_date,
        --datediff('2018-06-14', DATE, birth_date)) as age,
        weight,
        height,
        city,
        national_team_affiliation_id,
        affiliation_id

    from source

)

select * from renamed