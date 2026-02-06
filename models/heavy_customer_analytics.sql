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
上流: int_customer_heavy_metrics (中間層)
処理行数: 約1億行（2000日 × 50 × 10 × 100顧客）
実行時間: 約2分以上（Snowflake）
*/

-- 大量の行を生成（約5.5年分の日付）
with date_spine as (
    select
        dateadd(day, seq4(), '2020-01-01'::date) as date_day,
        seq4() as day_seq
    from table(generator(rowcount => 2000))  -- 約5.5年分
),

-- 行数を50倍に増やす
multiplier_1 as (
    select seq4() + 1 as mult_id_1
    from table(generator(rowcount => 50))
),

-- さらに10倍に増やす
multiplier_2 as (
    select seq4() + 1 as mult_id_2
    from table(generator(rowcount => 10))
),

-- 顧客 × 日付 × 50 × 10 = 約1億行を生成
massive_combinations as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        d.date_day,
        d.day_seq,
        m1.mult_id_1,
        m2.mult_id_2,
        -- 複数のハッシュ計算（CPU負荷増加）
        md5(concat(c.customer_id::string, d.date_day::string, m1.mult_id_1::string)) as hash_1,
        sha1(concat(c.first_name, c.last_name, d.day_seq::string)) as hash_2,
        md5(concat(hash(c.customer_id)::string, m2.mult_id_2::string)) as hash_3
    from {{ ref('int_customer_heavy_metrics') }} c
    cross join date_spine d
    cross join multiplier_1 m1
    cross join multiplier_2 m2
),

-- 重い集計処理（複数の window 関数）
heavy_aggregation as (
    select
        customer_id,
        first_name,
        last_name,
        date_day,
        mult_id_1,
        mult_id_2,
        -- Window関数による負荷：顧客ごとの累積値
        sum(mult_id_1) over (partition by customer_id order by date_day, mult_id_1) as running_total_id1,
        -- Window関数による負荷：100行移動平均（非常に重い）
        avg(mult_id_2) over (partition by customer_id order by date_day rows between 100 preceding and current row) as complex_rolling_avg,
        -- ランク付けによるソート負荷
        rank() over (partition by date_day order by hash_1) as daily_rank,
        -- CPU計算負荷：三角関数など
        sin(mult_id_1)::float * cos(mult_id_2)::float as compute_intensive_val,
        current_timestamp() as processed_at
    from massive_combinations
)

select * from heavy_aggregation