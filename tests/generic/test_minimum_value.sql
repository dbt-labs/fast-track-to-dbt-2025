{% test minimum_value(model, column_name, min_value) %}

-- Nulls are checked separately with not_null when the column is required.
select
    {{ column_name }}
from {{ model }}
where {{ column_name }} < {{ min_value }}

{% endtest %}
