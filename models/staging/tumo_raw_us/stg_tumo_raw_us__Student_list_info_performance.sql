with 

source as (

    select * from {{ source('tumo_raw_us', 'Student_list_info_performance') }}

),

renamed as (

    select
        username as user_id,
        location,
        tumo_id,
        --birth_date_of,
        safe.parse_date('%b %e, %Y', birth_date_of) as birth_date,
        --registration_date,
        --attending_since,
        safe.parse_date('%b %e, %Y', attending_since) as first_day_date,
        --path_date,
        safe.parse_date('%b %e, %Y', path_date) as path_date,
        --termination_date,
        safe.parse_date('%b %e, %Y', termination_date) as churn_date,
        --continuous_absence,
        --present,
        present_ratio,
        --regular_present,
        --awarded,
        --rejected,
        --completed,
        --incomplete,
        --withdrawn,
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