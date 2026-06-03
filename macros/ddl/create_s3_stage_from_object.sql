{% macro create_s3_stage_from_object(
    object_name,
    bucket_url,
    database_name=None,
    schema_name=None,
    storage_integration=None,
    file_format=None,
    copy_options=None,
    comment=None,
    trim_prefix_chars=3
) %}

    {% set path_suffix = object_name[trim_prefix_chars:] ~ '/' %}
    {% set stage_name = object_name %}
    {% set rendered_file_format = file_format %}

    {% if file_format and database_name and schema_name and '.' not in file_format %}
        {% set rendered_file_format = database_name ~ '.' ~ schema_name ~ '.' ~ file_format %}
    {% endif %}

    {% set ddl %}
        create or replace stage {{ stage_name }}
            url = '{{ bucket_url ~ path_suffix }}'
            {% if storage_integration %}
            storage_integration = {{ storage_integration }}
            {% endif %}
            {% if rendered_file_format %}
            file_format = {{ rendered_file_format }}
            {% endif %}
            {% if copy_options %}
            copy_options = ({{ copy_options }})
            {% endif %}
            {% if comment %}
            comment = '{{ comment | replace("'", "''") | replace("\n", " ") }}'
            {% endif %}
    {% endset %}

    {% do run_query(ddl) %}
    {{ return(ddl) }}

{% endmacro %}
