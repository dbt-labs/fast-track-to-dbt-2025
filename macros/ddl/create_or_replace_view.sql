{% macro create_or_replace_view(view_name, select_sql, comment=None) %}

    {% set ddl %}
        create or replace view {{ view_name }}
        {% if comment %}
        comment = '{{ comment | replace("'", "''") }}'
        {% endif %}
        as
        {{ select_sql }}
    {% endset %}

    {% do run_query(ddl) %}
    {{ return(ddl) }}

{% endmacro %}
