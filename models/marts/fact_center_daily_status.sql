{{
    config(
        materialized='table'
    )
}}

WITH ref AS(

    SELECT * FROM {{ ref('stg_tumo_raw_us__Center_activity_daily_status') }}

)
  
, active_daily AS( -- do AVG to get nb depending time period
    SELECT 
        date,
        location,
        status,
        students_count AS nb_active
    FROM ref
    WHERE status = 'Active'
    ORDER BY date
)
, new_closed_daily AS( -- remove cumul sum to get the value per day.
    SELECT 
        date,
        location,
        status,
        students_count AS total_closed,
        COALESCE(students_count - LAG(students_count, 1) OVER(ORDER BY date ASC), FIRST_VALUE(students_count) OVER(ORDER BY date ASC)) AS nb_closed -- to get closed_nb per day.
    FROM ref
    WHERE status = 'Closed'
)
, subscribed_daily AS( -- do AVG to get nb depending time period
    SELECT 
        date,
        location,
        SUM(students_count) AS nb_subscribed
    FROM ref
    WHERE status IN ('Freeze', 'Active', 'Preclosed', 'Suspended')
    GROUP BY date, location
    ORDER BY date
)
, new_registred_daily AS( -- remove cumul sum to get the value per day.
    SELECT 
        date,
        location,
        --students_count AS stock_registred,
        COALESCE(IF(students_count - LAG(students_count, 1) OVER(ORDER BY date ASC) <= 0, 0, students_count - LAG(students_count, 1)OVER(ORDER BY date ASC)), FIRST_VALUE(students_count) OVER(ORDER BY date ASC)) AS nb_new_registred -- to get closed_nb per day.
    FROM ref
    WHERE status = 'Registered'
    ORDER BY date
)

, join_table AS(
    SELECT
        COALESCE(n.date, s.date, a.date, c.date) AS date,
        COALESCE(n.location, s.location, a.location, c.location) AS location,
        nb_new_registred,
        nb_subscribed,
        nb_active,
        COALESCE(nb_closed, 0) AS nb_closed,
        COALESCE(total_closed, 0) AS total_closed
    FROM new_registred_daily n
    FULL JOIN subscribed_daily s
        ON n.date = s.date
    FULL JOIN active_daily a
        ON n.date = a.date
    FULL JOIN new_closed_daily c
        ON n.date = c.date
    ORDER BY date ASC  
)

, date_info_added AS(
    SELECT 
        p.date,
        DATE_TRUNC(p.date, MONTH) AS date_month,
        nb_new_registred,
        nb_subscribed,
        nb_active,
        nb_closed,
        total_closed,
        location,
        year,
        school_year,
        month
      FROM join_table p
      LEFT JOIN {{ ref('dim_date') }} d
        ON p.date = d.date 
)

SELECT * FROM date_info_added
ORDER BY date