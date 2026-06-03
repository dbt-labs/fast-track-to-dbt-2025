{% macro wsh_dump_column_metadata(database_name=None, schema_name=None, identifier=None) %}

    {% if not schema_name or not identifier %}
        {% do exceptions.raise_compiler_error('wsh_dump_column_metadata requires schema_name and identifier') %}
    {% endif %}

    {% set relation = adapter.get_relation(
        database=database_name,
        schema=schema_name,
        identifier=identifier
    ) %}

    {% if relation is none %}
        {% do exceptions.raise_compiler_error('Relation not found for ' ~ (database_name ~ '.' if database_name else '') ~ schema_name ~ '.' ~ identifier) %}
    {% endif %}

    {% set columns = adapter.get_columns_in_relation(relation) %}

    {% do log('relation.database = ' ~ relation.database, info=True) %}
    {% do log('relation.schema = ' ~ relation.schema, info=True) %}
    {% do log('relation.identifier = ' ~ relation.identifier, info=True) %}
    {% do log('relation.type = ' ~ relation.type, info=True) %}
    {% do log('column_count = ' ~ (columns | length), info=True) %}

    {% for col in columns %}
        {% do log('--- column ' ~ loop.index ~ ' ---', info=True) %}
        {% do log('name = ' ~ col.name, info=True) %}
        {% do log('data_type = ' ~ col.data_type, info=True) %}
        {% do log('quoted = ' ~ col.quoted, info=True) %}
        {% if col.char_size is not none %}
            {% do log('char_size = ' ~ col.char_size, info=True) %}
        {% endif %}
        {% if col.numeric_precision is not none %}
            {% do log('numeric_precision = ' ~ col.numeric_precision, info=True) %}
        {% endif %}
        {% if col.numeric_scale is not none %}
            {% do log('numeric_scale = ' ~ col.numeric_scale, info=True) %}
        {% endif %}
    {% endfor %}

    {{ return(columns) }}

{% endmacro %}
