{% test valid_expression(model, expression) %}

-- A NULL predicate is also a failure, so missing values cannot silently pass.
select *
from {{ model }}
where not coalesce(({{ expression }}), false)

{% endtest %}
