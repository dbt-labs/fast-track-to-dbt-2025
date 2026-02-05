-- dbt モデル (customers) を変更
{% macro add_test_customer() %}
    {% set sql %}
        INSERT INTO {{ ref('customers') }} (customer_id, first_name, last_name, number_of_orders)
        VALUES ((SELECT MAX(customer_id) + 1 FROM {{ ref('customers') }}), 'Test', 'Customer', 0)
    {% endset %}
    {% do run_query(sql) %}
    {{ log("Test customer added to customers model", info=True) }}
{% endmacro %}

{% macro remove_test_customer() %}
    {% set sql %}
        DELETE FROM {{ ref('customers') }}
        WHERE first_name = 'Test' AND last_name = 'Customer'
    {% endset %}
    {% do run_query(sql) %}
    {{ log("Test customer removed from customers model", info=True) }}
{% endmacro %}
