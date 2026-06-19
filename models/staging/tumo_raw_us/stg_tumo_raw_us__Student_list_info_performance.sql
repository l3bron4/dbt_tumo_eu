with 

source as (

    select * from {{ source('tumo_raw_us', 'Student_list_info_performance') }}

),

renamed as (

    select
        username,
        location,
        tumo_id,
        registration_date,
        attending_since,
        continuous_absence,
        present,
        present_ratio,
        birth_date_of,
        path_date,
        termination_date,
        regular_present,
        awarded,
        rejected,
        completed,
        incomplete,
        withdrawn,
        all_selection,
        selection_1,
        selection_2,
        selection_3

    from source

)

select * from renamed