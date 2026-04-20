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
