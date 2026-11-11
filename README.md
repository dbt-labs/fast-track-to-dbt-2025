# Customer and order analytics

This dbt project transforms Jaffle Shop application customer and order records into customer summaries and an order-volume leaderboard on Snowflake.

## Project structure

- `models/staging/_sources.yml`: source table and column definitions for `raw.jaffle_shop.customers` and `raw.jaffle_shop.orders`.
- `models/staging/`: source-aligned models that standardize identifiers without filtering rows.
- `models/marts/`: customer dimension, order fact, and customer order rankings.
- `tests/`: customer-summary reconciliation test and its documentation.
- `analyses/`, `macros/`, `seeds/`, and `snapshots/`: currently contain no dbt resources.

Model and column definitions live in the YAML files alongside the SQL. All model output columns and all source columns selected by the project have descriptions there.

## Models and grain

| Model | Grain | Purpose |
| --- | --- | --- |
| `stg_customers` | One row per source customer | Rename the customer identifier and select customer names. |
| `stg_orders` | One row per source order | Standardize order and customer identifiers and preserve order dates and statuses. |
| `dim_customers` | One row per customer | Retain all customers and calculate order counts and first and most recent order dates. |
| `fct_orders` | One row per order | Expose staged order attributes for downstream aggregation. |
| `customer_order_rankings` | One row per customer | Rank all customers by order volume, including customers without orders. |

## Transformation rules

- No model filters orders by date or status. Counts include all available orders, not just completed orders.
- `dim_customers.number_of_orders` counts non-null order IDs from `stg_orders`; `customer_order_rankings.total_orders` counts non-null order IDs from `fct_orders`. Neither calculation uses a distinct count.
- Customers without orders have zero order counts and null first and most recent order dates.
- `order_rank` uses `rank()` over `total_orders` descending. Equal totals share a rank and leave gaps after ties, such as `1, 1, 3`. Ranking does not guarantee result row order.
- These models summarize the available source data; they do not preserve historical snapshots of customer attributes or ranks.
- Mart models default to tables in `dbt_project.yml`; `dim_customers` explicitly overrides this to a view.

## Data quality

Existing tests cover source key uniqueness and nullability, order-to-customer relationships, and the configured order statuses: `placed`, `shipped`, `completed`, `return_pending`, and `returned`.

Mart tests cover customer and order keys, selected relationships, order counts, and rank nullability. The custom `assert_customer_order_summary_consistent` test reconciles customer counts and dates with `fct_orders`, checks that every dimension customer appears in the rankings, and requires positive, non-null ranks. It does not verify exact rank values.

## Validation in dbt Studio

Run commands through Studio's command interface:

```text
dbt parse
dbt build --select +customer_order_rankings
```

The build selector includes all five models and their applicable tests through the ranking model's upstream dependencies. Description-only documentation changes do not require rebuilding warehouse relations.

See the adjacent YAML descriptions for column-level lineage, calculations, null behavior, and status handling.
