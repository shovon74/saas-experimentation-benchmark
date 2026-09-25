-- Dimension table: one row per account, ready for use in dashboards
-- and joins. Built directly from staging since no additional
-- transformation logic is needed yet.

with accounts as (

    select * from {{ ref('stg_accounts') }}

),

final as (

    select
        account_id,
        industry,
        arr_tier,
        onboarding_date,
        date_diff(current_date(), onboarding_date, month) as tenure_months

    from accounts

)

select * from final