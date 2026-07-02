import requests
import psycopg2
import schedule
import time
from datetime import datetime

# ─── Config ───────────────────────────────────────────────────────────────────
DB_CONFIG = {
    "host":     "localhost",
    "port":     5432,
    "dbname":   "cryptodb",
    "user":     "postgres",
    "password": "postgres123",   # apna password daalo
}

API_URL    = "https://api.coingecko.com/api/v3/coins/markets"
API_PARAMS = {
    "vs_currency": "usd",
    "order":       "market_cap_desc",
    "per_page":    10,
    "page":        1,
    "sparkline":   False,
}

# ─── Database ─────────────────────────────────────────────────────────────────
def save_to_db(coins):
    conn = psycopg2.connect(**DB_CONFIG)
    cur  = conn.cursor()
    for coin in coins:
        cur.execute("""
            INSERT INTO crypto_prices (
                coin_id, coin_name, symbol,
                current_price, market_cap, volume_24h,
                price_change_24h, high_24h, low_24h, rank
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (
            coin["id"], coin["name"], coin["symbol"].upper(),
            coin["current_price"], coin["market_cap"],
            coin["total_volume"], coin["price_change_percentage_24h"],
            coin["high_24h"], coin["low_24h"], coin["market_cap_rank"],
        ))
    conn.commit()
    cur.close()
    conn.close()

# ─── Fetcher ──────────────────────────────────────────────────────────────────
def fetch_and_store():
    now = datetime.now().strftime("%H:%M:%S")
    print(f"\n[{now}] Fetching from CoinGecko...")

    try:
        res = requests.get(API_URL, params=API_PARAMS, timeout=10)

        if res.status_code == 200:
            data = res.json()
            save_to_db(data)
            print(f"✅ Saved {len(data)} coins\n")
            print(f"{'Coin':<14} {'Price':>12}  {'24h':>7}")
            print("─" * 38)
            for c in data:
                chg   = c['price_change_percentage_24h'] or 0
                arrow = "▲" if chg >= 0 else "▼"
                print(f"{c['name']:<14} ${c['current_price']:>11,.2f}  {arrow}{abs(chg):.2f}%")

        elif res.status_code == 429:
            print("⚠️  Rate limited — waiting 60s...")
            time.sleep(60)
        else:
            print(f"❌ API Error {res.status_code}")

    except Exception as e:
        print(f"❌ Error: {e}")

# ─── Main ─────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print("🚀 Crypto Data Collector Started!")
    print("📡 Fetching every 5 minutes | Ctrl+C to stop\n")

    fetch_and_store()                              # turant ek baar
    schedule.every(5).minutes.do(fetch_and_store) # phir har 5 min

    while True:
        schedule.run_pending()
        time.sleep(1)
