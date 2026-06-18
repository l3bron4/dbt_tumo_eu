with 

source as (

    select * from {{ source('tumo_raw_data', 'AF_list') }}

),

renamed as (

    select
        skill,
        placement,
        position,
        bonus,
        activity,
        activity_name_en_fr

    from source

)

select * from renamed