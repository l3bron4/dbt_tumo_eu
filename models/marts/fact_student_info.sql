{{
    config(
        materialized='table'
    )
}}

SELECT * FROM {{ ref('stg_tumo_raw_us__Student_list_info_performance') }}