# oca-locator
A lightweight Bash script tool to locate and analyze Netflix Open Connect Appliances (OCA). Detects ISP/Owner, IP Addresses, and Network Latency directly from your terminal."


# 🚀 Netflix OCA Locator

**Netflix OCA Locator** adalah sebuah tool berbasis Bash script yang dirancang untuk mendeteksi dan menganalisis infrastruktur **Open Connect Appliance (OCA)** milik Netflix yang sedang melayani jaringan internet Anda secara real-time.

Tool ini sangat berguna bagi *Network Engineer*, *ISP Administrator*, atau antusias jaringan untuk memantau apakah trafik Netflix mereka dilayani melalui server lokal (**On-Net**) atau melalui jalur Peering/Transit (**Off-Net**).

---

## ✨ Fitur Utama
- **Fast.com API Integration**: Mengambil token secara dinamis dari infrastruktur Fast.com terbaru.
- **Persistent Caching**: Menggunakan sistem cache token untuk menghindari blokir *rate-limit* (Tarpitting) dari firewall Netflix.
- **ISP & Ownership Detection**: Mengidentifikasi pemilik IP server OCA menggunakan lookup WHOIS otomatis.
- **Dual Version**:
    - `oca-locator.sh`: Versi standar untuk pengecekan cepat.
    - `oca-locator-latency.sh`: Versi diagnosa dengan tambahan informasi Latensi (Ping).
- **Clean Table Output**: Tampilan terminal yang rapi dengan format tabel dan pewarnaan teks.

---

## 📋 Prasyarat
Pastikan sistem Anda (Linux, WSL, atau macOS) sudah terinstall paket-paket berikut:
- `curl` (untuk request API)
- `whois` (untuk cek pemilik IP)
- `python3` (untuk parsing data JSON)
- `dnsutils` (untuk resolusi IP/getent)

**Cara Install di Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install curl whois python3 dnsutils -y
```

## 🚀 Cara Penggunaan
Clone repository ini dan berikan izin eksekusi pada file script:
```bash
git clone https://github.com/frizanwr/oca-locator.git
cd oca-locator
chmod +x oca-locator.sh oca-locator-latency.sh
```

Untuk menjalankan oca-locator
```bash
bash oca-locator.sh
```
atau
```bash
./oca-locator.sh
```

Untuk menjalankan oca-locator-latency (Dengan tambahan fitur pengukur latensi)
```bash
bash oca-locator-latency.sh
```
atau
```bash
./oca-locator-latency.sh
```

## 📊 Contoh Output Terminal oca-locator.sh
```bash
=== NETFLIX OPEN CONNECT APPLIANCE (OCA) LOCATOR ===
-----------------------------------------------------------------------------------------------------------------------
HOSTNAME OCA                                            | IP ADDRESS       | OWNER/ISP                                    
-----------------------------------------------------------------------------------------------------------------------
ipv4-c002-hlp001-iixapjii-isp.1.oca.nflxvideo.net       | 203.119.55.12    | Indonesia Network Information Center         
ipv4-c093-sin001-ix.1.oca.nflxvideo.net                 | 23.246.55.133    | Netflix Streaming Services Inc. (SS-144)     
ipv4-c090-sin001-ix.1.oca.nflxvideo.net                 | 23.246.54.142    | Netflix Streaming Services Inc. (SS-144)     
ipv4-c063-vie001-ix.1.oca.nflxvideo.net                 | 45.57.16.162     | Netflix Streaming Services Inc. (SS-144)     
ipv4-c082-vie001-ix.1.oca.nflxvideo.net                 | 45.57.17.132     | Netflix Streaming Services Inc. (SS-144)     
-----------------------------------------------------------------------------------------------------------------------
Status: Success | Source: Fast.com API
```

## 📊 Contoh Output Terminal oca-locator-latency.sh
```bash
=== NETFLIX OPEN CONNECT APPLIANCE (OCA) LOCATOR ===
------------------------------------------------------------------------------------------------------------------------------
HOSTNAME OCA                                       | IP ADDRESS      | LATENCY    | OWNER/ISP                               
------------------------------------------------------------------------------------------------------------------------------
ipv4-c002-hlp001-iixapjii-isp.1.oca.nflxvideo.net  | 203.119.55.12   | 7.530ms    | Indonesia Network Information Center    
ipv4-c069-sin001-ix.1.oca.nflxvideo.net            | 23.246.54.165   | 22.783ms   | Netflix Streaming Services Inc. (SS-144)
ipv4-c103-sin001-ix.1.oca.nflxvideo.net            | 23.246.55.143   | 19.417ms   | Netflix Streaming Services Inc. (SS-144)
ipv4-c081-vie001-ix.1.oca.nflxvideo.net            | 45.57.16.165    | 165.941ms  | Netflix Streaming Services Inc. (SS-144)
ipv4-c067-vie001-ix.1.oca.nflxvideo.net            | 45.57.17.161    | 170.288ms  | Netflix Streaming Services Inc. (SS-144)
------------------------------------------------------------------------------------------------------------------------------
Status: Success | Source: Fast.com API
```
