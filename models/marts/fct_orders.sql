with
    orders as (
        select customer_sk, order_id, order_date, status 
        from {{ ref("stg_orders") }} 
        left join {{ ref('dim_customers') }} using (customer_id)
    )

    --,final as (select orders.* from orders)

select * from  orders
--final
