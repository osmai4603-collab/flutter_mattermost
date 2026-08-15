# توثيق وتحليل كلاسات الحماية والتشفير (`lib/core/security`) ومخططات تدفق البيانات (DataFlow)

## 1. الملخص التنفيذي والنظرة العامة

يمثل المجلد `lib/core/security` في مشروع `flutter_mattermost` طبقة الأمان والتشفير بين الطرفين (End-to-End Encryption - E2EE) الخاصة بالوسائط والمكالمات والتراسل.

تضمن هذه الطبقة:
* تشفير دفقات الوسائط المباشرة (Audio/Video Frames) على مستوى WebRTC RTP Senders باستخدام خوارزمية **AES-GCM**.
* إشراك محرك `frameCryptorFactory` لمنع خوادم الوسائط الوسيطة (SFU) من التجسس على محتوى الصوت والفيديو.
* تبديل وتدوير مفاتيح التشفير (`Key Rotation`) عبر خدمة تبادل المفاتيح المستقلة.

---

## 2. جدول الكلاسات والمكونات الأساسية في المجلد

| الملف (File) | اسم الكلاس / العنصر | النمط والتعيين | الوظيفة الرئيسية (Role & Purpose) |
|---|---|---|---|
| [e2ee_engine.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/security/e2ee_engine.dart) | `E2EEEngine` | `@lazySingleton` | **محرك التشفير بين الطرفين (E2EE)**: إدارة التشفير المباشر للإطارات الصوتية والمرئية لـ WebRTC باستخدام `FrameCryptor` وخوارزمية AES-GCM. |
| [key_exchange_service.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/security/key_exchange_service.dart) | `KeyExchangeService` | `@lazySingleton` | **خدمة تبادل وتدوير المفاتيح**: توليد مفاتيح الجلسة، وتوزيعها، واستقبال التحديثات من الطرف الآخر عبر إشارات WebSocket. |

---

## 3. الشرح التفصيلي ومخطط التدفق (DataFlow) لكل كلاس

---

### 3.1 كلاس `E2EEEngine`

#### الوظيفة وآلية العمل:
* يتعامل مع مكتبة `flutter_webrtc` لإنشاء `KeyProvider` مشترك يحتوي على مفتاح التشفير و `ratchetSalt`.
* يمر على جميع المسارات المباشرة (RTP Senders) في الـ `RTCPeerConnection` لربطها بـ `FrameCryptor`.
* يفعّل التشفير فورياً (`Algorithm.kAesGcm`) بحجم 256 بت لكل إطار صوت أو فيديو يغادر جهاز المستخدم قبل إرساله للشبكة.

#### مخطط تدفق البيانات (DataFlow):

```mermaid
flowchart TD
    SETUP["setupE2EE(RTCPeerConnection, key)"] --> CREAT_KP["KeyProvider Creation (frameCryptorFactory)"]
    CREAT_KP --> SET_KEY["setSharedKey(Uint8List.fromList(key))"]
    SET_KEY --> GET_SENDERS["pc.getSenders()"]

    GET_SENDERS --> LOOP_SENDERS{"لكل Sender محلي"}
    LOOP_SENDERS -->|track != null| FC_CREATE["createFrameCryptorForRtpSender(kAesGcm)"]
    FC_CREATE --> FC_ENABLE["fc.setEnabled(true) & setKeyIndex(0)"]
    FC_ENABLE --> MAP_FC["حفظ في _frameCryptors['local_trackId']"]
    MAP_FC --> LOOP_SENDERS

    LOOP_SENDERS -->|انتهاء| READY["المكالمة مشفرة E2EE بنجاح"]
    
    DISP["dispose()"] --> CLEAR["إلغاء FrameCryptors & KeyProvider"]
```

---

### 3.2 كلاس `KeyExchangeService`

#### الوظيفة وآلية العمل:
* يحتفظ بمفتاح الجلسة الحالي `_currentSessionKey`.
* يقدم آلية تدوير المفاتيح `rotateKey()` لإنشاء مفاتيح عشوائية جديدة ذات مهلة زمنية.
* يستقبل التحديثات `handleRemoteKeyUpdate(key)` عند استلام مفاتيح متبادلة جديدة من المشاركين الآخرين عبر WebSocket Signaling.

#### مخطط تدفق البيانات (DataFlow):

```mermaid
flowchart LR
    subgraph LocalGen ["التوليد المحلي"]
        ROT["rotateKey()"] --> GEN["توليد مفتاح عشوائي برقم الزمني"]
        GEN --> SAVE_LOCAL["حفظ _currentSessionKey"]
        SAVE_LOCAL --> SIG_OUT["إرسال الإشارة عبر WebSocket Signaling"]
    end

    subgraph RemoteRecv ["الاستقبال الخارجي"]
        SIG_IN["استلام إشارة مفتاح جديد"] --> HANDLE["handleRemoteKeyUpdate(key)"]
        HANDLE --> SAVE_REMOTE["تحديث _currentSessionKey"]
        SAVE_REMOTE --> E2EE_UPDATE["تطبيق المفتاح في E2EEEngine"]
    end
```

---

## 4. المخطط الشامل لمعمارية وتدفق بيانات الأمان (Unified Security DataFlow)

```mermaid
sequenceDiagram
    autonumber
    actor Alice as العميل (Alice)
    participant KES as KeyExchangeService
    participant Engine as E2EEEngine
    participant RTC as WebRTC RTP Sender
    actor Bob as المتصل (Bob)

    Note over Alice,Bob: 1. مرحلة تبديل وتوليد المفاتيح
    Alice->>KES: rotateKey()
    KES->>KES: توليد المفتاح المشترك (Session Key)
    KES-->>Bob: إرسال المفتاح عبر قناة WebSocket المشفرة

    Note over Alice,Bob: 2. إعداد محرك التشفير E2EE
    Alice->>Engine: setupE2EE(peerConnection, sessionKey)
    Engine->>Engine: createDefaultKeyProvider & setSharedKey
    Engine->>RTC: createFrameCryptorForRtpSender(kAesGcm)
    RTC-->>Engine: FrameCryptor Enabled

    Note over Alice,Bob: 3. سريان الوسائط المباشرة المشفرة
    RTC->>RTC: Encrypt Raw Media Frame with AES-GCM
    RTC-->>Bob: إرسال الإطارات المشفرة عبر شبكة الوسائط (UDP 8443)
```
