with 

source as (

    select * from {{ source('tumo_raw_us', 'AF_jira_tickets') }}

),

renamed as (

    select
        ticket_id,
        created_date,
        center_city,
        skillactivity,
        software_version,
        issue_type,
        priority,
        description

    from source

)

select * from renamed