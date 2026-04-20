#!/bin/bash
# STARGATE CLUSTER V2 - LOCAL BACKUP - LAURO SERGIO VASCONCELLOS BECK

echo "Architecting Stargate v2 local files..."

# 1. DDL SCHEMA
cat << 'SQL' > stargate_schema.sql
-- STARGATE CLUSTER V2: INFRASTRUCTURE DDL
CREATE TABLE principal_usd_master (
    usd_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bbdxy_price NUMBER(10,2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE big_oil_master (
    company_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_name VARCHAR2(100),
    ticker VARCHAR2(20),
    region VARCHAR2(50),
    current_price NUMBER(10,2),
    usd_ref_id NUMBER REFERENCES principal_usd_master(usd_id)
);

CREATE TABLE big_oil_projections (
    projection_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_id NUMBER REFERENCES big_oil_master(company_id),
    target_12m NUMBER(10,2),
    target_18m NUMBER(10,2),
    confidence_score NUMBER(3,2),
    risk_factor VARCHAR2(50)
);
SQL

# 2. INGESTION PAYLOAD
cat << 'SQL' > data_ingest_payload.sql
-- FORCE INGESTION: GLOBAL ENERGY PERIMETER
INSERT INTO principal_usd_master (bbdxy_price) VALUES (1195.27);

DECLARE
    v_usd_id NUMBER;
BEGIN
    SELECT MAX(usd_id) INTO v_usd_id FROM principal_usd_master;

    -- USA & EUROPE
    INSERT INTO big_oil_master (company_name, ticker, region, current_price, usd_ref_id) VALUES ('Chevron', 'CVX', 'USA', 183.99, v_usd_id);
    INSERT INTO big_oil_master (company_name, ticker, region, current_price, usd_ref_id) VALUES ('ExxonMobil', 'XOM', 'USA', 146.44, v_usd_id);
    INSERT INTO big_oil_master (company_name, ticker, region, current_price, usd_ref_id) VALUES ('Shell', 'SHEL', 'EUROPE', 87.81, v_usd_id);
    
    -- LATAM & ASIA
    INSERT INTO big_oil_master (company_name, ticker, region, current_price, usd_ref_id) VALUES ('Petrobras', 'PBR', 'LATAM', 21.50, v_usd_id);
    INSERT INTO big_oil_master (company_name, ticker, region, current_price, usd_ref_id) VALUES ('PetroChina', '857.HK', 'ASIA', 1.37, v_usd_id);
    INSERT INTO big_oil_master (company_name, ticker, region, current_price, usd_ref_id) VALUES ('Sinopec', 'SHI', 'ASIA', 0.82, v_usd_id);

    -- GENERATE PROJECTIONS
    INSERT INTO big_oil_projections (company_id, target_12m, target_18m, confidence_score, risk_factor)
    SELECT company_id, current_price * 1.15, current_price * 1.30, 0.90, 'HORMUZ_ALPHA'
    FROM big_oil_master;

    COMMIT;
END;
/
SQL

# 3. BLOOMBERG REPORT QUERY
cat << 'SQL' > alpha_report.sql
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
SQL

echo "Deployment complete. 4 files generated."
