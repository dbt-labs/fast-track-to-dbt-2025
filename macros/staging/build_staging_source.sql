{% macro build_staging_source(source_name, table_name, include_columns=None, derived_columns=None) %}

    {% set include_columns = include_columns or ['*'] %}
    {% set derived_columns = derived_columns or [] %}

select
    {%- for column in include_columns %}
    {{ column }}{% if not loop.last or derived_columns | length > 0 %},{% endif %}
    {%- endfor %}
    {%- for derived_column in derived_columns %}
    {{ derived_column.expression }} as {{ derived_column.alias }}{% if not loop.last %},{% endif %}
    {%- endfor %}
from {{ source(source_name, table_name) }}

{% endmacro %}
