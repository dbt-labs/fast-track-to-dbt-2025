with event_type as (
    select * from {{ source('fifa', 'event_type') }}
)

select 
    id as event_type_id
    , replace(lower(name),' ','_') as event_type_name
from event_type
