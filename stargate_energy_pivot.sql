SET PAGESIZE 50;
SET LINESIZE 150;
COLUMN TICKER FORMAT A10;
COLUMN SECTOR FORMAT A20;
COLUMN TARGET_PRICE FORMAT A15;
COLUMN VECTOR_STATUS FORMAT A25;

PROMPT =================================================================================
PROMPT         STARGATE v15.0 | ENERGY SECTOR & BRENT ($102.30) PIVOT
PROMPT =================================================================================

SELECT * FROM (
    SELECT 'CVX' AS TICKER, 'BIG_OIL' AS SECTOR, '$185.50' AS TARGET_PRICE, 'HORMUZ_STRESS_WINNER' AS VECTOR_STATUS FROM DUAL
    UNION ALL
    SELECT 'XOM', 'BIG_OIL', '$132.10', 'SUPPLY_CHAIN_ALPHA' FROM DUAL
    UNION ALL
    SELECT 'SHEL', 'LNG_GLOBAL', '$82.40', 'EUROPE_PIVOT_SECURED' FROM DUAL
) ORDER BY TARGET_PRICE DESC;

PROMPT ---------------------------------------------------------------------------------
PROMPT [ARCHITECTURAL INTEL: THE $102.30 FLOOR]
PROMPT >> Geopolitical Alpha: Blockade creates permanent backwardation.
PROMPT >> Oracle Advantage: Real-time correlation between Brent and JPM NII.
PROMPT ---------------------------------------------------------------------------------
