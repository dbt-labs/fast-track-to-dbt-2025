{{
    config(
        materialized = 'table',
    )
}}

with base_dates as (

    {{
        dbt.date_spine(
            'day',
            "cast('2015-01-01' as date)",
            "cast('2030-01-01' as date)"
        )
    }}

),

final as (

    select cast(date_day as date) as date_day
    from base_dates

)

select *
from final
