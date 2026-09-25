-- Fact table: experiment performance aggregated by variant and
-- engagement tier. This is the analysis-ready table that the
-- statistics notebook and dashboard will query directly.

with engagement as (

    select * from {{ ref('int_player_engagement') }}

),

aggregated as (

    select
        experiment_variant,
        engagement_tier,

        count(*) as total_players,

        countif(retained_day_1) as retained_day_1_count,
        countif(retained_day_7) as retained_day_7_count,

        round(safe_divide(countif(retained_day_1), count(*)), 4) as retention_rate_day_1,
        round(safe_divide(countif(retained_day_7), count(*)), 4) as retention_rate_day_7,

        round(avg(total_game_rounds), 2) as avg_game_rounds

    from engagement
    group by experiment_variant, engagement_tier

)

select * from aggregated