with customer_order_summary as (

    select
        customer_id,
        count(*) as total_orders,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        datediff(
            month,
            date_trunc('month', min(order_date)),
            date_trunc('month', max(order_date))
        ) + 1 as active_months

    from {{ ref('fct_orders') }}

    group by 1

),

final as (

    select
        customer_id,
        total_orders,
        first_order_date,
        most_recent_order_date,
        active_months,
        total_orders / active_months::float as average_orders_per_month,
        dense_rank() over (
            order by total_orders / active_months::float desc
        ) as customer_rank_by_average_order_volume

    from customer_order_summary

)

select *
from final
