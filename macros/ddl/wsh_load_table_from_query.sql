{% macro wsh_load_table_from_query(
    target_relation,
    select_sql,
    warehouse=None,
    delete_before_insert=false,
    truncate_before_insert=false
) %}

    {% if warehouse %}
        {% do run_query('use warehouse ' ~ warehouse) %}
    {% endif %}

    {% if truncate_before_insert %}
        {% do run_query('truncate table ' ~ target_relation) %}
    {% elif delete_before_insert %}
        {% do run_query('delete from ' ~ target_relation) %}
    {% endif %}

    {% set insert_sql %}
        insert into {{ target_relation }}
        {{ select_sql }}
    {% endset %}

    {% do run_query(insert_sql) %}
    {{ return(insert_sql) }}

{% endmacro %}
