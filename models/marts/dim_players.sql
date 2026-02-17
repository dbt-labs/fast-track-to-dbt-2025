with dimplayer as (
    SELECT
    a.*,
    b.*
    FROM
    {{ ref('stg_player') }} a
    INNER JOIN
    {{ ref('stg_team') }} b
        on a.affiliation_id = b.affiliation_id
)

SELECT *
FROM dimplayer
