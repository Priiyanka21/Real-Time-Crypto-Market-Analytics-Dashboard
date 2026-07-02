<img width="1426" height="817" alt="Screenshot 2026-07-02 095235" src="https://github.com/user-attachments/assets/68315fff-63e5-48a2-8fb7-a1ac74aaf52c" />


# 🚀 Real-Time Cryptocurrency Analytics Dashboard
### Python | PostgreSQL | Power BI | CoinGecko API



---
![Dashboard Preview](![Uploading Screenshot 2026-07-02 095235.png…]
)
## 📌 Project Overview

An end-to-end **real-time data pipeline** that automatically fetches live cryptocurrency market data every 5 minutes from the CoinGecko API, stores it in a PostgreSQL database, and visualizes it through an interactive Power BI dashboard with 8+ charts and KPI cards.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **Python** | Data fetching, automation, DB connection |
| **PostgreSQL** | Structured data storage |
| **Power BI** | Interactive dashboard & visualization |
| **CoinGecko API** | Free real-time crypto market data |
| **psycopg2** | Python-PostgreSQL connector |
| **schedule** | Automated data refresh every 5 mins |

---

## 📊 Dashboard Features

### KPI Cards
- 💰 Total Price (USD)
- 📈 24h Trading Volume
- 🏦 Total Market Cap
- 📉 Avg 24h Price Change %

### Charts
- 📈 **Line Chart** — Price trend over time
- 🍩 **Donut Chart** — Market cap share by coin
- 📊 **Area Chart** — Volume trend over time
- ⏱️ **Gauge Chart** — Avg price change performance
- 🎀 **Ribbon Chart** — Coin ranking over time
- 📋 **Table** — Full live coin details
- 📊 **Bar Chart** — 24h Volume by coin

---

## ⚙️ How It Works

```
CoinGecko API
      ↓
Python Script (every 5 mins)
      ↓
PostgreSQL Database (crypto_prices table)
      ↓
Power BI Dashboard (live connection)
```

---

## 📁 Project Structure

```
crypto-analytics-dashboard/
├── main.py          # Python data pipeline script
├── setup.sql        # PostgreSQL database schema
├── dashboard.png    # Power BI dashboard screenshot
└── README.md        # Project documentation
```

---

## 🚀 How to Run This Project

### Step 1 — Prerequisites
- Python 3.x installed
- PostgreSQL installed
- Power BI Desktop installed

### Step 2 — Install Python Libraries
```bash
python -m pip install requests psycopg2-binary schedule
```

### Step 3 — Setup Database
- Open pgAdmin 4
- Create database: `cryptodb`
- Run `setup.sql` in Query Tool

### Step 4 — Update Config in main.py
```python
DB_CONFIG = {
    "host":     "localhost",
    "port":     5432,
    "dbname":   "cryptodb",
    "user":     "postgres",
    "password": "your_password_here",  # change this
}
```

### Step 5 — Run Python Script
```bash
python main.py
```

### Step 6 — Connect Power BI
- Open Power BI Desktop
- Get Data → PostgreSQL
- Server: `localhost:5432`
- Database: `cryptodb`
- Load `crypto_prices` table
- Build visuals!

---

## 📈 Sample Output

```
Crypto Data Collector Started!
Fetching every 5 minutes | Ctrl+C to stop

[14:20:15] Fetching from CoinGecko...
Saved 10 coins

Coin              Price        24h
--------------------------------------
Bitcoin       $62,400.00   UP 2.34%
Ethereum       $3,280.00   UP 1.82%
BNB              $420.00   UP 0.95%
Solana           $145.00  DOWN 0.42%
...
```

---

## 🎯 Key Learnings

- Built a complete **ETL pipeline** (Extract → Transform → Load)
- Connected **Python to PostgreSQL** using psycopg2
- Automated **scheduled tasks** in Python
- Designed **interactive Power BI** dashboards
- Worked with a **live REST API** (no API key needed!)
- Debugged real-world issues (DB connection, rate limits)

---

## 👩‍💻 Author

**Priyanka Maurya**
Data Analyst | Power BI | SQL | Python
[LinkedIn](https://www.linkedin.com/in/your-profile) | [GitHub](https://github.com/your-username)

---

## ⭐ If you found this helpful, give it a star!
