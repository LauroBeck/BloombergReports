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
