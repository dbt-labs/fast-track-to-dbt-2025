with validplayers as
(
    SELECT
    a.*
    FROM {{ ref('dim_players') }} a
    WHERE age BETWEEN 18 and 36
)

SELECT * FROM validplayers