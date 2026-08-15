# دليل إعداد خادم Mattermost للإنتاج

> دليل عملي لتهيئة خادم Mattermost مع NGINX كـ Reverse Proxy وشهادة Let's Encrypt
> ودعم WebSocket وWSS، مع إعداد اختياري لخادم TURN (coturn) للمكالمات.
> مرجع: [mattermost_realtime_analysis.md](mattermost_realtime_analysis.md) (القسمان 4.2 و 4.3).

---

## 1. إعدادات المنافذ والجدار الناري

```
┌─────────────────────────────────────────────────────────┐
│                    Firewall Rules                        │
├─────────────┬──────────┬────────────────────────────────┤
│ المنفذ      │ البروتوكول│ الوصف                          │
├─────────────┼──────────┼────────────────────────────────┤
│ 443         │ TCP      │ HTTPS (REST API + WSS)         │
│ 8065        │ TCP      │ Mattermost (بدون proxy)        │
│ 8443        │ UDP      │ rtcd Media Traffic              │
│ 3478        │ UDP/TCP  │ STUN/TURN                       │
│ 5349        │ TCP      │ TURN over TLS                   │
│ 49152-65535 │ UDP      │ coturn Relay Range               │
│ 5432        │ TCP      │ PostgreSQL (داخلي فقط)          │
│ 8075        │ TCP      │ Mattermost Cluster (داخلي)     │
├─────────────┴──────────┴────────────────────────────────┤
│ ⚠️ المنافذ 5432 و 8075 يجب ألا تكون مفتوحة للعموم      │
└─────────────────────────────────────────────────────────┘
```

بعد فتح المنفذين العامين فقط (443 و 3478)، قم بحجب 8065 عن العموم بحيث
لا يُفتح إلا للـ Reverse Proxy (والمنافذ الداخلية 5432/8075 تبقى داخل
الشبكة المحلية):

```bash
# فتح منفذ HTTPS و WebSocket
sudo ufw allow 443/tcp

# فتح منفذ STUN/TURN
sudo ufw allow 3478/udp
sudo ufw allow 3478/tcp
sudo ufw allow 5349/tcp

# فتح نطاق rtcd للمكالمات (اختياري — إن كنت تستخدم rtcd)
sudo ufw allow 8443/udp
sudo ufw allow 49152:65535/udp

# منفذ Mattermost — للـ proxy فقط وليس للعموم
sudo ufw allow from 127.0.0.1 to any port 8065 proto tcp
```

---

## 2. إعداد NGINX كـ Reverse Proxy

```nginx
# /etc/nginx/conf.d/mattermost.conf

upstream mattermost_backend {
    server 127.0.0.1:8065;
    keepalive 32;
}

server {
    listen 443 ssl http2;
    server_name mm.yourdomain.com;

    ssl_certificate     /etc/letsencrypt/live/mm.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mm.yourdomain.com/privkey.pem;

    # WebSocket Support — حاسم جداً
    location ~ /api/v4/websocket {
        proxy_pass http://mattermost_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # مهم: timeout طويل للـ WebSocket
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
    }

    # REST API + Static Files
    location / {
        proxy_pass http://mattermost_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        client_max_body_size 50M;
    }
}

# توجيه http → https
server {
    listen 80;
    server_name mm.yourdomain.com;
    return 301 https://$host$request_uri;
}
```

> ⚠️ **شرط أساسي**: يجب أن يتصل Mattermost بالعميل عبر نفس `host` الذي
> ستستخدمه في التطبيق، وأن يكون NGINX هو الواجهة الوحيدة للعموم (منفذ 8065
> محجوب عن العموم).

تفعيل الإعداد:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 3. إعداد Let's Encrypt (شهادة SSL)

```bash
# تثبيت certbot
sudo apt update
sudo apt install certbot python3-certbot-nginx

# إصدار الشهادة لاسم المجال (مع تجديد تلقائي)
sudo certbot --nginx -d mm.yourdomain.com

# التحقق من التجديد التلقائي
sudo certbot renew --dry-run
```

---

## 4. إعداد coturn TURN server (اختياري — للمكالمات عبر NAT)

```bash
# تثبيت coturn
sudo apt install coturn
```

الإعداد — `/etc/turnserver.conf`:

```ini
# عنوان الاستماع الخارجي (عنوان الخادم العام)
listening-port=3478
tls-listening-port=5349
fingerprint
lt-cred-mech

# نطاق relaying
relay-device=eth0
min-port=49152
max-port=65535

# بيانات المصادقة — تُنسخ في AppConfig (turnUsername / turnPassword)
user=mattermost-turn:CHANGE_ME_TURN_PASSWORD

realm=mm.yourdomain.com

# المسار إلى شهادة Let's Encrypt لتفعيل TURN over TLS
cert=/etc/letsencrypt/live/mm.yourdomain.com/fullchain.pem
pkey=/etc/letsencrypt/live/mm.yourdomain.com/privkey.pem
```

> ⚠️ **آمن**: استخدم `turnadmin` لإنشاء مستخدم بدل إدخال كلمة المرور
> كنص صريح، وقيّد كلمة مرور صريحة بالتطوير فقط:
> ```bash
> sudo turnadmin -k -u mattermost-turn -r mm.yourdomain.com -p CHANGE_ME_TURN_PASSWORD
> ```

التفعيل:

```bash
sudo systemctl enable coturn
sudo systemctl start coturn
```

---

## 5. التبديل من التطوير للإنتاج في التطبيق

في [`lib/app/config/app_config.dart`](../lib/app/config/app_config.dart):

| الإعداد | التطوير المحلي | الإنتاج |
|---------|---------------|---------|
| `useSSL` | `false` | `true` |
| `host` | `192.168.137.1` | `mm.yourdomain.com` |
| `turnServerUrl` | `null` | `turn:turn.yourdomain.com:3478` |
| `turnUsername` | — | مستخدم coturn |
| `turnPassword` | — | كلمة مرور coturn |

عند `useSSL = true`:
- `defaultBaseUrl` → `https://mm.yourdomain.com/api/v4`
- `defaultWebSocketUrl` → `wss://mm.yourdomain.com/api/v4/websocket`
- `activePort` → `443` (يُستخدم في فحص الاتصال)

بعد التبديل نفّذ اختبارات التحقق:

```bash
flutter test test/core/network/websocket_client_test.dart
flutter test test/core/sync/delta_sync_service_test.dart
flutter analyze
```

> 💡 إذا كانت المكالمات ستُفعّل لاحقاً فقط، أبقِ `turnServerUrl = null`
> لتعطيل TURN والاكتفاء بـ STUN، ويُستخدم `rtcdPort` (8443) لمسار الوسائط.
