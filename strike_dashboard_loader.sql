SET PAGESIZE 0;
SET FEEDBACK OFF;
SET VERIFY OFF;
SET HEADING OFF;

PROMPT { "strike_status": "SIGMA_HARDENED", "countdown": "10h 25m", "nodes": [

SELECT 
    JSON_OBJECT(
        'ticker'     VALUE TICKER,
        'status'     VALUE STATUS,
        'mcap'       VALUE MCAP,
        'target'     VALUE 1050,
        'sim_vector' VALUE VECTOR_SIM
    ) || ','
FROM (
    SELECT 'JPM' AS TICKER, 'ARMED' AS STATUS, 841.36 AS MCAP, 0.0482 AS VECTOR_SIM FROM DUAL
    UNION ALL
    SELECT 'GS', 'REALIZED_BEAT', 262.78, 0.1150 FROM DUAL
    UNION ALL
    SELECT 'C', 'ARMED', 216.56, 0.2240 FROM DUAL
);

PROMPT ] }
