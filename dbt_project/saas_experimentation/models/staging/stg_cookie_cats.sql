with source as (

    select * from {{ source('raw', 'raw_cookie_cats') }}

),

renamed as (

    select
        userid                          as user_id,
        version                         as experiment_variant,
        sum_gamerounds                  as total_game_rounds,
        cast(retention_1 as bool)       as retained_day_1,
        cast(retention_7 as bool)       as retained_day_7

    from source

)

select * from renamed