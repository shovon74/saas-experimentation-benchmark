-- Intermediate model: bucket players into engagement tiers and rank them
-- within their experiment variant, using window functions.
--
-- NTILE() for quartile bucketing, ROW_NUMBER() for within-group ranking,
-- and an aggregate window function for a running comparison metric.

with players as (

    select * from {{ ref('stg_cookie_cats') }}

),

engagement_buckets as (

    select
        user_id,
        experiment_variant,
        total_game_rounds,
        retained_day_1,
        retained_day_7,

        -- Split players into 4 engagement tiers based on how much they played,
        -- computed independently within each experiment variant so we're
        -- comparing like-for-like engagement levels across control/treatment.
        ntile(4) over (
            partition by experiment_variant
            order by total_game_rounds
        ) as engagement_quartile,

        -- Rank each player's engagement within their own variant.
        -- Rank 1 = least engaged player in that variant.
        row_number() over (
            partition by experiment_variant
            order by total_game_rounds
        ) as engagement_rank_in_variant,

        -- Running average of game rounds within the variant, ordered by
        -- engagement rank — shows how the average shifts as you move
        -- through the distribution (a common "cumulative metric" pattern).
        avg(total_game_rounds) over (
            partition by experiment_variant
            order by total_game_rounds
            rows between unbounded preceding and current row
        ) as running_avg_rounds_in_variant

    from players

),

labeled as (

    select
        *,
        case engagement_quartile
            when 1 then 'Low'
            when 2 then 'Medium-Low'
            when 3 then 'Medium-High'
            when 4 then 'High'
        end as engagement_tier

    from engagement_buckets

)

select * from labeled