{{
    config(
        materialized='table',
        tags=['heavy', 'analytics'],
        freshness={
            "build_after": {
                "count": 2,
                "period": "hour",
                "updates_on": "all"
            }
        }
    )
}}

/*
    このモデルは意図的に非常に重い処理を含んでいます。
    State-aware orchestration のデモ用に、変更がない場合は
    再ビルドをスキップすることで時間を節約できることを示します。
    
    処理行数: 約5000万行（2000日 × 25 × 10 × 100顧客）
    実行時間: 約1分以上（Snowflake）
    
    処理内容:
    - 5000万行のデータを生成
    - 複数の window 関数で重い計算
    - 複数のハッシュ関数で CPU 負荷を増加
*/

-- 大量の行を生成（約5.5年分の日付）
-- 合計: 2000日 × 25 × 10 × 100顧客 = 5000万行
with date_spine as (
    select
        dateadd(day, seq4(), '2020-01-01'::date) as date_day,
        seq4() as day_seq
    from table(generator(rowcount => 2000))  -- 約5.5年分
),

-- 行数を25倍に増やす
multiplier_1 as (
    select seq4() + 1 as mult_id_1
    from table(generator(rowcount => 25))
),

-- さらに10倍に増やす
multiplier_2 as (
    select seq4() + 1 as mult_id_2
    from table(generator(rowcount => 10))
),

-- 顧客 × 日付 × 100 × 10 = 数千万行を生成
-- 複数のハッシュ計算で CPU 負荷を増加
massive_combinations as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        d.date_day,
        d.day_seq,
        m1.mult_id_1,
        m2.mult_id_2,
        -- 複数のハッシュ計算（CPU負荷）
        md5(concat(c.customer_id::string, d.date_day::string, m1.mult_id_1::string)) as hash_1,
        sha1(concat(c.first_name, c.last_name, d.day_seq::string)) as hash_2,
        md5(concat(hash(c.customer_id)::string, m2.mult_id_2::string)) as hash_3
    from {{ ref('stg_customers') }} c
    cross join date_spine d
    cross join multiplier_1 m1
    cross join multiplier_2 m2
),

-- 注文データ
orders_data as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status
    from {{ ref('stg_orders') }} o
),

-- 重い集計処理（複数の window 関数）
heavy_aggregation as (
    select
        mc.customer_id,
        mc.first_name,
        mc.last_name,
        mc.date_day,
        mc.mult_id_1,
        mc.mult_id_2,
        -- 複数の集計関数
        count(distinct o.order_id) as orders_on_day,
        count(*) as row_count,
        -- 複数の window 関数（非常に重い）
        sum(count(distinct o.order_id)) over (
            partition by mc.customer_id 
            order by mc.date_day, mc.mult_id_1, mc.mult_id_2
            rows between unbounded preceding and current row
        ) as cumulative_orders,
        row_number() over (
            partition by mc.customer_id 
            order by mc.date_day, mc.mult_id_1, mc.mult_id_2
        ) as row_num,
        dense_rank() over (
            partition by mc.customer_id 
            order by mc.date_day
        ) as day_rank,
        lag(mc.date_day, 1) over (
            partition by mc.customer_id 
            order by mc.date_day, mc.mult_id_1, mc.mult_id_2
        ) as prev_date,
        lead(mc.date_day, 1) over (
            partition by mc.customer_id 
            order by mc.date_day, mc.mult_id_1, mc.mult_id_2
        ) as next_date
    from massive_combinations mc
    left join orders_data o 
        on mc.customer_id = o.customer_id 
        and mc.date_day = o.order_date
    group by 1, 2, 3, 4, 5, 6
),

-- 追加の集計レイヤー（さらに重くする）
secondary_aggregation as (
    select
        customer_id,
        first_name,
        last_name,
        date_day,
        max(cumulative_orders) as max_cumulative,
        avg(row_num) as avg_row_num,
        count(distinct day_rank) as unique_days,
        -- さらにハッシュ計算
        md5(listagg(row_num::string, ',') within group (order by mult_id_1, mult_id_2)) as agg_hash
    from heavy_aggregation
    group by 1, 2, 3, 4
),

-- 最終集計
final as (
    select
        customer_id,
        first_name,
        last_name,
        max(date_day) as latest_date,
        max(max_cumulative) as total_orders,
        sum(unique_days) as days_tracked,
        count(*) as total_records_processed,
        current_timestamp as processed_at
    from secondary_aggregation
    group by 1, 2, 3
)

select * from final
