-- ═══════════════════════════════════════════════════════════
--  Real-Time Cryptocurrency Analytics Dashboard
--  Database Setup Script
--  Author: Priyanka Maurya
--  Description: Creates all required tables, indexes and views
--               for the crypto analytics pipeline
-- ═══════════════════════════════════════════════════════════


-- ─── Step 1: Create Database ──────────────────────────────
-- Run this in pgAdmin by right-clicking PostgreSQL
-- → Create → Database → Name: cryptodb


-- ─── Step 2: Create Main Prices Table ────────────────────
-- Stores all cryptocurrency price data fetched from CoinGecko API
CREATE TABLE IF NOT EXISTS crypto_prices (
    id               SERIAL PRIMARY KEY,          -- Auto-incrementing unique ID
    fetched_at       TIMESTAMP DEFAULT NOW(),      -- Timestamp when data was fetched
    coin_id          VARCHAR(50)    NOT NULL,      -- CoinGecko coin identifier (e.g. "bitcoin")
    coin_name        VARCHAR(100)   NOT NULL,      -- Full coin name (e.g. "Bitcoin")
    symbol           VARCHAR(20),                  -- Coin symbol (e.g. "BTC")
    current_price    DECIMAL(20,8),               -- Current price in USD
    market_cap       BIGINT,                       -- Total market capitalization in USD
    volume_24h       BIGINT,                       -- 24-hour trading volume in USD
    price_change_24h DECIMAL(10,4),               -- Price change percentage in last 24 hours
    high_24h         DECIMAL(20,8),               -- Highest price in last 24 hours
    low_24h          DECIMAL(20,8),               -- Lowest price in last 24 hours
    rank             INT                           -- Market cap ranking (1 = highest)
);


-- ─── Step 3: Create Fetch Log Table ──────────────────────
-- Tracks each API fetch attempt — useful for monitoring pipeline health
CREATE TABLE IF NOT EXISTS fetch_log (
    id          SERIAL PRIMARY KEY,               -- Auto-incrementing unique ID
    fetched_at  TIMESTAMP DEFAULT NOW(),          -- Timestamp of fetch attempt
    coins_count INT,                              -- Number of coins fetched
    status      VARCHAR(20),                      -- Status: SUCCESS, ERROR, RATE_LIMITED
    error_msg   TEXT                              -- Error message if fetch failed
);


-- ─── Step 4: Create Indexes ───────────────────────────────
-- Indexes speed up Power BI queries significantly

-- Index on fetch time (most common filter in dashboards)
CREATE INDEX IF NOT EXISTS idx_fetched_at
    ON crypto_prices(fetched_at DESC);

-- Index on coin ID (used when filtering by specific coin)
CREATE INDEX IF NOT EXISTS idx_coin_id
    ON crypto_prices(coin_id);


-- ─── Step 5: Create Useful Views for Power BI ─────────────

-- View: Latest price for each coin (most recent record only)
CREATE OR REPLACE VIEW latest_prices AS
SELECT DISTINCT ON (coin_id)
    coin_id,
    coin_name,
    symbol,
    current_price,
    market_cap,
    volume_24h,
    price_change_24h,
    high_24h,
    low_24h,
    rank,
    fetched_at
FROM  crypto_prices
ORDER BY coin_id, fetched_at DESC;


-- View: Hourly average prices (useful for trend charts)
CREATE OR REPLACE VIEW hourly_avg AS
SELECT
    date_trunc('hour', fetched_at) AS hour,
    coin_name,
    AVG(current_price)             AS avg_price,
    MAX(high_24h)                  AS max_high,
    MIN(low_24h)                   AS min_low,
    AVG(volume_24h)                AS avg_volume
FROM  crypto_prices
GROUP BY 1, 2
ORDER BY 1 DESC, 2;


-- ─── Step 6: Verify Setup ─────────────────────────────────
-- Run these queries after Python script has fetched some data
-- to verify everything is working correctly

-- Check total records fetched
-- SELECT COUNT(*) AS total_records FROM crypto_prices;

-- Check latest prices for all coins
-- SELECT coin_name, current_price, price_change_24h, fetched_at
-- FROM   crypto_prices
-- ORDER  BY fetched_at DESC, rank ASC
-- LIMIT  10;

-- Check hourly averages
-- SELECT * FROM hourly_avg LIMIT 20;
