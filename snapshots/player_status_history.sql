{% snapshot player_status_history %}
    {{
        config(
            target_schema='snapshots',            
            unique_key='player_id',
            strategy='check',
            check_cols=['status'],
        )
    }}

    select * from {{ ref('player_status') }}
 {% endsnapshot %}


 