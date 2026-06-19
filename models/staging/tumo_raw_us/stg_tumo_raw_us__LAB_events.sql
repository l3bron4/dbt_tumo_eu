with 

source as (

    select * from {{ source('tumo_raw_us', 'LAB_events') }}

),

renamed as (

    select
        lesson_id,
        username as user_id,
        workshop,
        case
          when workshop_lvl = 1 then 'Level I'
          when workshop_lvl = 2 then 'Level II'
          when workshop_lvl = 3 then 'Level III'
          end
          as workshop_lvl,
        pass_status,
        --attendance,
        --star,
        start_date as lab_start_date,
        end_date as lab_end_date

    from source

)

select * from renamed