# Marts

Customer and order models for downstream analytics. Start with the model that matches the grain of your question.

## Model guide

| Model | Grain | Use for | Materialization |
| --- | --- | --- | --- |
| [`dim_customers`](dim_customers.sql) | One row per customer, including customers without orders | Customer-level analysis and order-history summaries | View |
| [`fct_orders`](fct_orders.sql) | One row per order | Order-level analysis across all order statuses | Table |
| [`customer_order_rankings`](customer_order_rankings.sql) | One row per customer | Ranking customers by all-time order count | Table |

Model and column definitions, along with data tests, live in the corresponding YAML files:

- [`dim_customers.yml`](dim_customers.yml)
- [`fct_orders.yml`](fct_orders.yml)
- [`customer_order_rankings.yml`](customer_order_rankings.yml)

## Data flow

- `stg_customers` and `stg_orders` feed `dim_customers`.
- `stg_orders` feeds `fct_orders`.
- `dim_customers` and `fct_orders` feed `customer_order_rankings`.

## Usage notes

- Order counts and date summaries include all order statuses; they are not restricted to completed orders.
- Customers without orders have zero order counts and null first/latest order dates.
- Customer rankings use descending order count. Tied counts share a rank, with gaps after ties.
- Join customers and orders on `customer_id`. This is a one-to-many join, so customer-level values repeat for each order; aggregate at the intended grain before summing customer-level measures.
- In `customer_order_rankings`, `number_of_orders` comes from the staging-based customer summary, while `total_orders` is counted from `fct_orders` and drives the ranking.

## Maintenance

Keep model and column descriptions in the YAML files. Update this guide when models, grains, dependencies, or usage conventions change.
