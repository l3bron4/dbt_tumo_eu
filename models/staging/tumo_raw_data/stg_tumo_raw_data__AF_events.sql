with 

source as (

    select * from {{ source('tumo_raw_data', 'AF_events') }}

),

renamed as (

    select
        act_id,
        username,
        skill,
        activity,
        reject_count,
        try_status,
        last_submission_date,
        last_examination_date,
        software_version,
        ab_test_group

    from source

)

select * from renamed