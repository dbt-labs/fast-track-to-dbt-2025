# Jaffle Shop customer and order analytics

This dbt project transforms replicated application customer and order data in
Snowflake into customer summaries, order facts, and customer order rankings.
The dbt project name is `fast_track_to_dbt`.

## Data flow and model grain

| Resource | Grain and purpose |
| --- | --- |
| `source('jaffle_shop', 'customers')` | One record per customer account in `RAW.JAFFLE_SHOP.CUSTOMERS`. |
| `source('jaffle_shop', 'orders')` | One record per order in `RAW.JAFFLE_SHOP.ORDERS`; `user_id` references the customer account. |
| `stg_customers` | One row per source customer; renames the key to `customer_id` and passes through names. |
| `stg_orders` | Intended to provide one row per order with its customer, date, and status; currently blocked by the ID alias issue below. |
| `dim_customers` | One row per customer, including customers without orders, with first/latest order dates and an order count. |
| `fct_orders` | One row per order, retaining all statuses from staging. |
| `customer_order_rankings` | One row per customer, retaining dimension columns and adding a fact-based order count and descending rank. |

`dim_customers` reads both staging models. `fct_orders` reads `stg_orders`.
`customer_order_rankings` reads both marts.

## Business rules

- All order statuses contribute to order counts; models do not filter to completed orders.
- `dim_customers.number_of_orders` counts non-null order IDs from staging.
- Customers without orders have an order count of zero and null first/latest order dates.
- `customer_order_rankings.total_orders` is calculated independently from `fct_orders`.
- Rankings use SQL `rank()`: tied counts share a rank, with gaps after ties.
- The source status test currently permits `placed`, `shipped`, `completed`,
  `return_pending`, and `returned`. Review this list when the application adds statuses.

## Documentation and data tests

Model and column descriptions live in standard dbt YAML alongside the models:

- `models/staging/_sources.yml`: source descriptions and source data tests.
- `models/staging/_staging.yml`: staging model and column descriptions.
- `models/marts/_marts.yml`: customer dimension and order fact descriptions and tests.
- `models/marts/customer_order_rankings.yml`: ranking descriptions and tests.

Source tests protect primary keys, required order fields, customer relationships,
and accepted statuses. Mart tests protect customer/order keys, customer
relationships, and required counts/ranks. Tests assert data expectations; they
do not replace a successful model build.

## Current build limitation

`models/staging/stg_orders.sql` aliases both `id` and `user_id` as `customer_id`.
This causes a duplicate-column error and leaves downstream models without the
`order_id` they reference. The staging model and dependent marts cannot build
successfully until that SQL issue is resolved. Documentation changes do not fix
or alter this behavior.

## Project layout

- `models/staging/`: source definitions and pass-through staging models.
- `models/marts/`: customer summaries, order facts, and customer rankings.
- `analyses/`, `macros/`, `seeds/`, `snapshots/`, and `tests/`: currently contain
  no project resources. Generic data tests are defined in model/source YAML.
- `dbt_project.yml`: project paths and materialization configuration. Marts
  default to tables; `dim_customers` explicitly uses a view.

See the [dbt documentation guide](https://docs.getdbt.com/docs/build/documentation)
for how these YAML descriptions appear in dbt documentation.
