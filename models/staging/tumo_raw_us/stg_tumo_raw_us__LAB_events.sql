with 

source as (

    select * from {{ source('tumo_raw_us', 'LAB_events') }}

),

renamed as (

    select
        lesson_id,
        username,
        workshop,
        workshop_lvl,
        pass_status,
        attendance,
        star,
        start_date,
        end_date

    from source

)

select * from renamed