with 

source as (

    select * from {{ source('tumo_raw_us', 'AF_list') }}

),

renamed as (

    select
        activity as activity_name,
        activity_name_en_fr,
        skill,
        placement as workshop_lvl,
        position,
        bonus

    from source
    where activity is not NULL

)

select * from renamed