#!/bin/bash

# Identitas
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
TOKEN_CACHE="/tmp/netflix_token_cache.txt"

# --- FUNGSI AMBIL TOKEN ---
fetch_new_token() {
    local JS_FILE=$(curl -s -L -H "User-Agent: $UA" https://fast.com/ | grep -oE "app-[a-z0-9]+\.js" | head -n 1)
    if [ -z "$JS_FILE" ]; then return 1; fi
    local NEW_TOKEN=$(curl -s -L -H "User-Agent: $UA" -H "Referer: https://fast.com/" \
              "https://fast.com/$JS_FILE" | tr '}' '\n' | grep -m 1 -oE 'token:"[a-zA-Z0-9]{32}"' | cut -d'"' -f2)
    [ -z "$NEW_TOKEN" ] && return 1
    echo "$NEW_TOKEN" > "$TOKEN_CACHE"
    echo "$NEW_TOKEN"
}

# --- LOGIKA TOKEN ---
if [ -f "$TOKEN_CACHE" ]; then
    TOKEN=$(cat "$TOKEN_CACHE")
else
    TOKEN=$(fetch_new_token)
fi

# --- AMBIL DATA ---
RESPONSE=$(curl -s -H "User-Agent: $UA" -H "Origin: https://fast.com" -H "Referer: https://fast.com/" \
               "https://api.fast.com/netflix/speedtest?https=true&token=$TOKEN&urlCount=5")

if echo "$RESPONSE" | grep -q "Unknown app token"; then
    rm "$TOKEN_CACHE"
    TOKEN=$(fetch_new_token)
    RESPONSE=$(curl -s -H "User-Agent: $UA" "https://api.fast.com/netflix/speedtest?https=true&token=$TOKEN&urlCount=5")
fi

# --- HEADER TABEL ---
echo -e "\n\e[1m=== NETFLIX OPEN CONNECT APPLIANCE (OCA) LOCATOR ===\e[0m"
echo "-----------------------------------------------------------------------------------------------------------------------"
printf "\e[1m%-55s | %-16s | %-45s\e[0m\n" "HOSTNAME OCA" "IP ADDRESS" "OWNER/ISP"
echo "-----------------------------------------------------------------------------------------------------------------------"

# --- PROSES BARIS PER BARIS ---
URLS=$(echo "$RESPONSE" | python3 -c "import sys, json; [print(x['url']) for x in json.load(sys.stdin)]")

for URL in $URLS; do
    # 1. Hostname
    HOST=$(echo "$URL" | sed -e 's|https://||' -e 's|/.*||')
    
    # 2. IP Address
    IP=$(getent hosts "$HOST" | awk '{print $1}' | head -n 1)
    
    if [ -z "$IP" ]; then
        IP="No Resolve"
        OWNER="-"
    else
        # 3. Owner/ISP (Dilebarkan ke 45 karakter agar tidak terpotong)
        OWNER=$(whois "$IP" | grep -iE "^descr:|^Organization:|^OrgName:|^as-name:" | head -n 1 | cut -d':' -f2 | sed 's/^[ \t]*//' | cut -c1-45)
        [ -z "$OWNER" ] && OWNER="Netflix Streaming"
    fi

    # Menampilkan hasil dengan warna (Cyan: Hostname, Green: IP)
    printf "\e[36m%-55s\e[0m | \e[32m%-16s\e[0m | %-45s\n" "$HOST" "$IP" "$OWNER"
done
echo "-----------------------------------------------------------------------------------------------------------------------"
echo -e "Status: \e[92mSuccess\e[0m | Source: \e[94mFast.com API\e[0m\n"
