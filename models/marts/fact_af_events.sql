{{
    config(
        materialized='table'
    )
}}

SELECT 
    act_id,
    user_id,
    e.workshop,
    workshop_lvl,
    l.activity_name,
    CONCAT(l.activity_name, " ", software_version) AS activity_and_version,
    bonus,
    reject_count,
    try_status,
    last_submission_date,
    last_examination_date,
    software_version,
    ab_test_group,
    IF(try_status = 'Awarded', 1, NULL) AS is_pass,
  FROM {{ ref('stg_tumo_raw_us__AF_events') }} e
  JOIN {{ ref('stg_tumo_raw_us__AF_list') }} l
    ON e.activity_name_en_fr = l.activity_name_en_fr



