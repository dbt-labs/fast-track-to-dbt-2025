{% test expression_is_true(model, expression, column_name=None) %}

select *
from {{ model }}
where not coalesce(({{ expression }}), false)

{% endtest %}
