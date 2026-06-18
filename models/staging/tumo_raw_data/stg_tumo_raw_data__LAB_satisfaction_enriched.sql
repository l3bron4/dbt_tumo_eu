with 

source as (

    select * from {{ source('tumo_raw_data', 'LAB_satisfaction_enriched') }}

),

renamed as (

    select
        timestamp_comment,
        workshop_lvl,
        workshop,
        satisfaction_on_5,
        tag_like,
        tag_dislike,
        comments

    from source

)

select * from renamed