{{
    config(
        materialized='table'
    )
}}

SELECT * FROM {{ ref('stg_tumo_raw_us__AF_jira_tickets') }}