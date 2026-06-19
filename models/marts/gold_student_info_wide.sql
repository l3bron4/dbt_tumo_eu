{{
    config(
        materialized='table'
    )
}}

WITH af_nb_act AS(
    SELECT 
      user_id,
      COUNT(act_id) AS nb_act,
    FROM {{ ref('fact_af_events') }}
    GROUP BY user_id  
  )

, lab_1st_date_nb_lab AS(
    SELECT 
      user_id,
      MIN(lab_start_date) AS lab_1_start_date,
      COUNT(lesson_id) AS nb_lab
    FROM {{ ref('fact_lab_events') }}
    GROUP BY user_id  
  )

, joined_table AS(
    SELECT
        location,
        s.user_id,
        tumo_id,
        birth_date,
        first_day_date,
        path_date,
        lab_1_start_date,
        churn_date,
        is_closed,
        all_selection,
        nb_act,
        nb_lab,
        present_ratio
    FROM {{ ref('fact_student_info') }} s
    LEFT JOIN lab_1st_date_nb_lab f
        ON s.user_id = f.user_id
    LEFT JOIN af_nb_act a
        ON s.user_id = a.user_id
) 

, parcours_duree_added AS(
    SELECT
        *,
        DATE_DIFF(IFNULL(churn_date, DATE("2025-08-31")), first_day_date, MONTH) AS duree_parcours_month,
        DATE_DIFF(IFNULL(churn_date, DATE("2025-08-31")), first_day_date, DAY) AS duree_parcours_day,
        DATE_DIFF(path_date, first_day_date, DAY) AS duree_orientation_day,
    FROM joined_table
)

, retention_group_added AS(
  SELECT
    *,
    CASE
        WHEN duree_parcours_month < 6 THEN "00 - 06 Months"
        WHEN duree_parcours_month >= 6  AND duree_parcours_month < 12 THEN "06 - 12 Months"
        WHEN duree_parcours_month >= 12 AND duree_parcours_month < 18 THEN "12 - 18 Months"
        WHEN duree_parcours_month >= 18 AND duree_parcours_month < 24 THEN "18 - 24 Months"
        ELSE "24+ Months"
        END
        AS retention_group
    FROM parcours_duree_added
    ORDER BY retention_group  
)

SELECT * FROM retention_group_added
