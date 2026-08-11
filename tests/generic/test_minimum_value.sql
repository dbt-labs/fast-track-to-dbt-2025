{% test minimum_value(model, column_name, minimum_value) %}

select *
from {{ model }}
where {{ column_name }} < {{ minimum_value }}

{% endtest %}
