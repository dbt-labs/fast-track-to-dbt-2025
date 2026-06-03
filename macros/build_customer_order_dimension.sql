{% macro build_customer_order_dimension(
    customer_relation,
    order_relation,
    customer_id_column='customer_id',
    customer_first_name_column='first_name',
    customer_last_name_column='last_name',
    order_id_column='order_id',
    order_customer_id_column='customer_id',
    order_date_column='order_date'
) %}

with customers as (

    select
        {{ customer_id_column }} as customer_id,
        {{ customer_first_name_column }} as first_name,
        {{ customer_last_name_column }} as last_name
    from {{ customer_relation }}

),

orders as (

    select
        {{ order_id_column }} as order_id,
        {{ order_customer_id_column }} as customer_id,
        {{ order_date_column }} as order_date
    from {{ order_relation }}

),

customer_orders as (

    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
    from customers
    left join customer_orders using (customer_id)

)

select *
from final

{% endmacro %}
