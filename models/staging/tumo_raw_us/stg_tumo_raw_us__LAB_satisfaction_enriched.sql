with 

source as (

    select * from {{ source('tumo_raw_us', 'LAB_satisfaction_enriched') }}

),

renamed as (

    select
        concat('SATIS-', row_number() over()) as satisfaction_id, -- primary_key added
        timestamp_comment as comment_timestamp,
        case
            when workshop_lvl = 'Lab niveau 1' then 'Level I'
            when workshop_lvl = 'Lab niveau 2' then 'Level II'
            when workshop_lvl = 'Lab niveau 3' then 'Level III'
            end
            as workshop_lvl,
        workshop,
        satisfaction_on_5,
        tag_like,
        tag_dislike,
        comments

    from source
    where satisfaction_on_5 in (1,2,3,4,5)
)

select * from renamed