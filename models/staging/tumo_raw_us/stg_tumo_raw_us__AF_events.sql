with 

source as (

    select * from {{ source('tumo_raw_us', 'AF_events') }}

),

renamed as (

    select
        act_id,
        username as user_id,
        skill,
        activity,
        reject_count,
        try_status,
        last_submission_date,
        last_examination_date,
        software_version,
        ab_test_group

    from source
    where try_status in ('Awarded', 'Rejected')
)

select * from renamed