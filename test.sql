-- ============================================================
-- Demo/Test Data Setup for Snowflake - Pfizer Dashboard
-- Database: TEST
-- ============================================================

USE DATABASE TEST;

USE SCHEMA PUBLIC;


-- ============================================================
-- 1. SALES TABLE - Product sales by region
-- ============================================================
CREATE OR REPLACE TABLE SALES (
    sale_id         NUMBER AUTOINCREMENT PRIMARY KEY,
    sale_date       DATE,
    product_name    VARCHAR(100),
    region          VARCHAR(50),
    country         VARCHAR(50),
    units_sold      NUMBER,
    unit_price      FLOAT,
    revenue         FLOAT,
    rep_name        VARCHAR(100)
);

INSERT INTO SALES (sale_date, product_name, region, country, units_sold, unit_price, revenue, rep_name) VALUES
    ('2026-01-05', 'Paxlovid',     'North America', 'USA',     1200, 530.00, 636000.00,  'Alice Johnson'),
    ('2026-01-10', 'Eliquis',      'North America', 'USA',      980, 290.00, 284200.00,  'Bob Smith'),
    ('2026-01-15', 'Prevnar 20',   'Europe',        'Germany',  750, 210.00, 157500.00,  'Claire Müller'),
    ('2026-01-20', 'Xeljanz',      'Europe',        'France',   430, 480.00, 206400.00,  'David Dupont'),
    ('2026-01-25', 'Ibrance',      'APAC',          'Japan',    560, 870.00, 487200.00,  'Yuki Tanaka'),
    ('2026-02-03', 'Paxlovid',     'North America', 'Canada',   400, 530.00, 212000.00,  'Alice Johnson'),
    ('2026-02-08', 'Eliquis',      'Europe',        'UK',       810, 310.00, 251100.00,  'Emma Clarke'),
    ('2026-02-14', 'Prevnar 20',   'APAC',          'Australia',390, 220.00,  85800.00,  'Liam Brown'),
    ('2026-02-20', 'Ibrance',      'North America', 'USA',      670, 870.00, 582900.00,  'Bob Smith'),
    ('2026-02-27', 'Xeljanz',      'APAC',          'India',    290, 460.00, 133400.00,  'Priya Patel'),
    ('2026-03-05', 'Paxlovid',     'Europe',        'Germany',  510, 530.00, 270300.00,  'Claire Müller'),
    ('2026-03-12', 'Eliquis',      'North America', 'USA',     1100, 290.00, 319000.00,  'Alice Johnson'),
    ('2026-03-18', 'Ibrance',      'Europe',        'France',   340, 870.00, 295800.00,  'David Dupont'),
    ('2026-03-25', 'Prevnar 20',   'North America', 'USA',      920, 210.00, 193200.00,  'Bob Smith'),
    ('2026-04-02', 'Xeljanz',      'APAC',          'Japan',    210, 480.00, 100800.00,  'Yuki Tanaka'),
    ('2026-04-10', 'Paxlovid',     'APAC',          'Australia',330, 530.00, 174900.00,  'Liam Brown'),
    ('2026-04-15', 'Eliquis',      'APAC',          'India',    460, 280.00, 128800.00,  'Priya Patel'),
    ('2026-04-22', 'Ibrance',      'North America', 'Canada',   280, 870.00, 243600.00,  'Emma Clarke'),
    ('2026-05-01', 'Prevnar 20',   'Europe',        'UK',       610, 210.00, 128100.00,  'Emma Clarke'),
    ('2026-05-08', 'Paxlovid',     'North America', 'USA',     1400, 530.00, 742000.00,  'Alice Johnson');


-- ============================================================
-- 2. CLINICAL TRIALS TABLE
-- ============================================================
CREATE OR REPLACE TABLE CLINICAL_TRIALS (
    trial_id        VARCHAR(20) PRIMARY KEY,
    trial_name      VARCHAR(200),
    product         VARCHAR(100),
    phase           VARCHAR(20),
    status          VARCHAR(50),
    start_date      DATE,
    end_date        DATE,
    participants    NUMBER,
    country         VARCHAR(50),
    success_rate    FLOAT
);

INSERT INTO CLINICAL_TRIALS VALUES
    ('PFZ-2024-001', 'Paxlovid Long COVID Study',         'Paxlovid',   'Phase 3', 'Completed',  '2024-01-15', '2025-06-30', 3200, 'USA',       0.82),
    ('PFZ-2024-002', 'Eliquis Pediatric Trial',           'Eliquis',    'Phase 2', 'Completed',  '2024-03-01', '2025-09-01',  640, 'Germany',   0.74),
    ('PFZ-2024-003', 'Prevnar 20 Elderly Population',     'Prevnar 20', 'Phase 3', 'Active',     '2024-06-01', '2026-12-31', 5100, 'USA',       NULL),
    ('PFZ-2025-001', 'Ibrance Combination Therapy',       'Ibrance',    'Phase 2', 'Active',     '2025-01-10', '2026-09-30',  820, 'France',    NULL),
    ('PFZ-2025-002', 'Xeljanz RA New Dosing',             'Xeljanz',    'Phase 3', 'Active',     '2025-03-15', '2027-03-15', 2400, 'UK',        NULL),
    ('PFZ-2025-003', 'Paxlovid Variant B Study',          'Paxlovid',   'Phase 2', 'Recruiting', '2025-07-01', '2026-12-01',  400, 'Japan',     NULL),
    ('PFZ-2025-004', 'Novel Oncology Compound X',         'Compound X', 'Phase 1', 'Recruiting', '2025-09-01', '2026-06-01',   80, 'Australia', NULL),
    ('PFZ-2026-001', 'Eliquis Stroke Prevention Update',  'Eliquis',    'Phase 3', 'Planned',    '2026-06-01', '2028-06-01', 4200, 'Canada',    NULL);


-- ============================================================
-- 3. INVENTORY TABLE - Supply chain stock levels
-- ============================================================
CREATE OR REPLACE TABLE INVENTORY (
    inventory_id    NUMBER AUTOINCREMENT PRIMARY KEY,
    product_name    VARCHAR(100),
    warehouse       VARCHAR(100),
    region          VARCHAR(50),
    stock_units     NUMBER,
    reorder_level   NUMBER,
    last_updated    TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO INVENTORY (product_name, warehouse, region, stock_units, reorder_level) VALUES
    ('Paxlovid',   'Memphis DC',       'North America', 45000, 10000),
    ('Paxlovid',   'Frankfurt Hub',    'Europe',        28000,  8000),
    ('Paxlovid',   'Singapore Hub',    'APAC',          19000,  6000),
    ('Eliquis',    'Memphis DC',       'North America', 62000, 15000),
    ('Eliquis',    'Frankfurt Hub',    'Europe',        41000, 12000),
    ('Eliquis',    'Singapore Hub',    'APAC',           8500, 10000),  -- LOW STOCK
    ('Prevnar 20', 'Memphis DC',       'North America', 33000,  8000),
    ('Prevnar 20', 'Frankfurt Hub',    'Europe',        17000,  5000),
    ('Ibrance',    'Memphis DC',       'North America', 12000,  4000),
    ('Ibrance',    'Frankfurt Hub',    'Europe',         3200,  4000),  -- LOW STOCK
    ('Xeljanz',    'Memphis DC',       'North America', 25000,  6000),
    ('Xeljanz',    'Singapore Hub',    'APAC',          14000,  5000);


-- ============================================================
-- 4. MONTHLY KPI SUMMARY VIEW
-- ============================================================
CREATE OR REPLACE VIEW MONTHLY_REVENUE_KPI AS
SELECT
    DATE_TRUNC('month', sale_date)  AS month,
    region,
    product_name,
    SUM(revenue)                    AS total_revenue,
    SUM(units_sold)                 AS total_units,
    COUNT(*)                        AS num_transactions,
    ROUND(AVG(unit_price), 2)       AS avg_unit_price
FROM TEST.PUBLIC.SALES
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;


-- ============================================================
-- 5. LOW STOCK ALERT VIEW
-- ============================================================
CREATE OR REPLACE VIEW LOW_STOCK_ALERTS AS
SELECT
    product_name,
    warehouse,
    region,
    stock_units,
    reorder_level,
    (reorder_level - stock_units) AS units_short
FROM TEST.PUBLIC.INVENTORY
WHERE stock_units < reorder_level
ORDER BY units_short DESC;


-- ============================================================
-- VERIFY DATA
-- ============================================================
SELECT 'SALES'           AS tbl, COUNT(*) AS "rows" FROM TEST.PUBLIC.SALES
UNION ALL
SELECT 'CLINICAL_TRIALS' ,       COUNT(*)            FROM TEST.PUBLIC.CLINICAL_TRIALS
UNION ALL
SELECT 'INVENTORY'       ,       COUNT(*)            FROM TEST.PUBLIC.INVENTORY;