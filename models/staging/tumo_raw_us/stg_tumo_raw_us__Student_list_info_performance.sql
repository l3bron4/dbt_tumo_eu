with 

source as (

    select * from {{ source('tumo_raw_us', 'Student_list_info_performance') }}

),

renamed as (

    select
        username as user_id,
        location,
        tumo_id,
        safe.parse_date('%b %e, %Y', birth_date_of) as birth_date,
        safe.parse_date('%b %e, %Y', attending_since) as first_day_date,
        safe.parse_date('%b %e, %Y', path_date) as path_date,
        safe.parse_date('%b %e, %Y', termination_date) as churn_date,
        present_ratio,
        all_selection,
        selection_1,
        selection_2,
        selection_3,
        case
          when termination_date = 'null' then 'no'
          else 'yes'
          end
          as is_closed

    from source

)

select * from renamed