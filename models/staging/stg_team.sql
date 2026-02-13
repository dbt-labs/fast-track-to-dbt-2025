with team as (
    select * from {{ source('fifa', 'team') }}
)

select 
    id as team_id
    , name_short as team_name
    , symid as country_code
    , affiliation_id
from team

