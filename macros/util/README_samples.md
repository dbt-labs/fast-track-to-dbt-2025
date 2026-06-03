# Sample macro usage

## Staging source passthrough

```sql
{{
    build_staging_source(
        source_name='jaffle_shop',
        table_name='customers'
    )
}}
```

## Staging source with derived audit column

```sql
{{
    build_staging_source(
        source_name='jaffle_shop',
        table_name='orders',
        include_columns=['id', 'user_id', 'order_date', 'status'],
        derived_columns=[
            {'expression': 'current_timestamp()', 'alias': 'aud_time'}
        ]
    )
}}
```

## Customer-order dimension

```sql
{{
    build_customer_order_dimension(
        customer_relation=ref('stg_jaffle_shop__customers'),
        order_relation=ref('stg_jaffle_shop__orders')
    )
}}
```

## Snowflake stage DDL

```sql
{{
    create_s3_stage(
        stage_name='raw.jaffle_shop.customer_stage',
        bucket_url='s3://my-bucket/',
        path_suffix='customers/',
        storage_integration='MY_STORAGE_INT',
        file_format='raw.jaffle_shop.my_csv_format',
        copy_options="on_error = 'continue'",
        comment='Stage for customer files'
    )
}}
```

Run DDL macros with `dbt run-operation`.
