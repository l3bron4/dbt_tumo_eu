with 

source as (

    select * from {{ source('tumo_raw_us', 'Center_activity_daily_status') }}

),

renamed as (

    select
        date,
        location,
        status,
        students_count

    from source

)

select * from renamed