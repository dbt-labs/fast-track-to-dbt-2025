select 
    payment_id,
    sum(amount) as transaction_value
from {{ ref('stg_stripe__payments') }}
group by 1 
having (transaction_value <0)