with source as (

    select * from {{ source('raw', 'raw_accounts') }}

),

renamed as (

    select
        account_id,
        industry,
        arr_tier,
        cast(onboarding_date as date) as onboarding_date

    from source

)

select * from renamed