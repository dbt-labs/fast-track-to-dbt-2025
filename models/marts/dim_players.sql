select A.*, B.team_name, B.country_code from {{ ref('stg_player') }} A
join {{ ref('stg_team') }} B on B.affiliation_id=A.affiliation_id
