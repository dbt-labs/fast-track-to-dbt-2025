{% snapshot player_status_history %}
    {{
        config(          
            unique_key='player_id',
            strategy='check',
            check_cols=['status']
        )
    }}

    select * from {{ ref('player_status') }}
 {% endsnapshot %}


 