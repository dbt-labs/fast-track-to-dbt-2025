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
        CAST(FLOOR(months_between(date '2018-06-14', source.birth_date) / 12) AS int) AS age,
        --DATEDIFF(DATE '2018-06-14', birth_date, YEAR) as age,
        weight,
        height,
        city,
        national_team_affiliation_id,
        affiliation_id

    from source

)

select * from renamed