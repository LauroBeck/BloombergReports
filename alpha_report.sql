-- BLOOMBERG TERMINAL: THE ASIA TRADE REPORT
SET PAGESIZE 100;
SET LINESIZE 160;
COLUMN company_name FORMAT A18;
COLUMN ticker FORMAT A10;
COLUMN proj_gain_18m FORMAT A12;

SELECT 
    b.company_name,
    b.ticker,
    b.region,
    p.target_18m,
    ROUND(b.current_price / NVL(u.bbdxy_price, 1195.27), 4) AS usd_relative_strength,
    ROUND(((p.target_18m - b.current_price) / b.current_price) * 100, 1) || '%' AS proj_gain_18m
FROM big_oil_master b
JOIN big_oil_projections p ON b.company_id = p.company_id
LEFT JOIN principal_usd_master u ON b.usd_ref_id = u.usd_id
ORDER BY usd_relative_strength DESC;
