with stg_event as (
    select * from {{ ref('stg_event') }}
)
, stg_event_type as (
    select * from {{ ref('stg_event_type') }}
)
, final as (
    select 
        stg_event.event_pk
        , stg_event.event_id
        , stg_event.event_type_id
        , stg_event.game_id
        , stg_event.period_id
        , stg_event.period_minute
        , stg_event.period_second
        , stg_event.player_id
        , stg_event.team_id
        , stg_event.event_time
        , stg_event_type.event_type_name
    from stg_event
    left join stg_event_type on stg_event.event_type_id = stg_event_type.event_type_id
)

select * from final 