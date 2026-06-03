{% macro create_s3_stage(
    stage_name,
    bucket_url,
    path_suffix='',
    storage_integration=None,
    file_format=None,
    copy_options=None,
    comment=None
) %}

    {% set ddl %}
        create or replace stage {{ stage_name }}
            url = '{{ bucket_url ~ path_suffix }}'
            {% if storage_integration %}
            storage_integration = {{ storage_integration }}
            {% endif %}
            {% if file_format %}
            file_format = {{ file_format }}
            {% endif %}
            {% if copy_options %}
            copy_options = ({{ copy_options }})
            {% endif %}
            {% if comment %}
            comment = '{{ comment | replace("'", "''") }}'
            {% endif %}
    {% endset %}

    {% do run_query(ddl) %}
    {{ return(ddl) }}

{% endmacro %}
