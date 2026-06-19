{{
    config(
        materialized='table'
    )
}}

SELECT * FROM {{ ref('stg_tumo_raw_us__LAB_satisfaction_enriched') }}