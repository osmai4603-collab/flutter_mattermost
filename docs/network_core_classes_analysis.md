# توثيق وتحليل كلاسات شبكة الاتصال (`lib/core/network`) ومخططات تدفق البيانات (DataFlow)

## 1. الملخص التنفيذي والنظرة العامة

يمثل المجلد `lib/core/network` في مشروع `flutter_mattermost` الطبقة المسؤولة عن جميع الاتصالات الشبكية مع خادم Mattermost.

تضمن هذه الطبقة:
* إدارة طلبات **REST API** عبر حزمة Dio المحسّنة بالمُتلقفات (Interceptors).
* إدارة الاتصال المستمر ثنائي الاتجاه **WebSocket Hub** وتتبع تسلسل الأحداث المباشرة (Realtime Events).
* كشف واختبار الاتصال الشبكي بالخادم عبر الـ LAN والمنافذ النشطة.
* معالجة أخطاء المصادقة، وإعادة المحاولة التلقائية عند انقطاع الاتصال (Exponential Backoff & Jitter).

---

## 2. جدول الكلاسات والمكونات الأساسية في المجلد

| الملف (File) | اسم الكلاس / العنصر | النمط والتعيين | الوظيفة الرئيسية (Role & Purpose) |
|---|---|---|---|
| [api_client.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/api_client.dart) | `ApiClient` | `@lazySingleton` | **عميل HTTP الرئيسي**: يغلّف Dio لتنفيذ عمليات `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `HEAD` ومعالجة الأخطاء وتحويلها لـ `ApiResult`. |
| [api_result.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/api_result.dart) | `ApiResult` (`ApiSuccess` / `ApiFailure`) | Sealed Class | **نمط النتيجة آمنة الأنواع**: لتمثيل نجاح العملية أو فشلها بشكل صريح بدون استثناءات غير معالجة. |
| [api_error.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/api_error.dart) | `ApiError` والتفريعات | Sealed Class | **تسلسل أخطاء الـ API**: تمثيل تصنيفي للأخطاء (`NetworkError`, `AuthError`, `ValidationError`, `PermissionError`, `ServerError`, إلخ). |
| [connectivity_monitor.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/connectivity_monitor.dart) | `ConnectivityMonitor` | `@lazySingleton` | **مراقب الاتصال الشبكي**: يفحص الاتصال بالشبكة واختبار التوصيل المباشر بخادم Mattermost (Socket Connect) لدعم شبكات الـ LAN المحمية. |
| [server_manager.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/server_manager.dart) | `ServerManager` | `@singleton` | **مدير عنوان الخادم**: حفظ وتحديث عنوان الخادم النشط وتحديث الـ BaseURL في `ApiClient` ديناميكياً. |
| [session_controller.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/session_controller.dart) | `SessionController` | `@singleton` | **متحكم الجلسة**: بث أحداث حالة الجلسة (`SessionEvent.expired`, `restored`, `loggedOut`) لتنبيه التطبيق عند انتهاء صلاحية التوكن. |
| [websocket_client.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/websocket_client.dart) | `WebSocketClientManager` | `@lazySingleton` | **مدير الـ WebSocket الرئيسي (Hub)**: يدير اتصال الـ WebSocket المباشر (`/api/v4/websocket`)، وبث الأحداث المطبّعة (`TypedWebSocketEvent`). |
| [auth_interceptor.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/interceptors/auth_interceptor.dart) | `AuthInterceptor` | Interceptor | **متلقّف المصادقة**: إرفاق `Authorization: Bearer`, `Cookie`, و `X-CSRF-Token` بالطلبات، وإطلاق حدث انقضاء الجلسة عند استلام HTTP 401. |
| [connectivity_interceptor.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/interceptors/connectivity_interceptor.dart) | `ConnectivityInterceptor` | Interceptor | **متلقّف الاتصال الشبكي**: رفض الطلبات مبكراً قبل إرسالها عند عدم وجود اتصال شبكي لتوفير موارد المكونات. |
| [retry_interceptor.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/interceptors/retry_interceptor.dart) | `RetryInterceptor` | Interceptor | **متلقّف إعادة المحاولة**: إعادة محاولة الطلبات الفاشلة بسبب أخطاء الشبكة المؤقتة أو أخطاء الخادم (500, 502, 503, 504) بتأخير تصاعدي. |

---

## 3. الشرح التفصيلي ومخطط التدفق (DataFlow) لكل كلاس

---

### 3.1 كلاس `ApiClient`

#### الوظيفة وآلية العمل:
* يغلف كائن `Dio` لتهيئة الأعدادات القياسية للـ HTTP (مثل `baseUrl`, `connectTimeout`, `headers`).
* يوجه طلبات الـ Plugins المستقلة تلقائياً عبر دالة `_resolveEndpoint` مثل مسارات `/plugins/com.*` و `/plugins/playbooks/*`.
* يحول استجابات واستثناءات Dio إلى نمط آمن للأنواع `ApiResult<T>` عبر دالة `_mapDioError`.

#### مخطط تدفق البيانات (DataFlow):

```mermaid
flowchart TD
    REQ_CALL["طلب من الـ Repository (GET/POST/PUT/DELETE)"] --> RESOLVE["تنسيق المسار (_resolveEndpoint)"]
    RESOLVE --> DIO_EXEC["تنفيذ Dio Request"]
    
    subgraph InterceptorStack ["سلسلة المتلقفات (Interceptors)"]
        AUTH_INT["AuthInterceptor (Headers)"]
        RETRY_INT["RetryInterceptor (Exponential Backoff)"]
        LOG_INT["LogInterceptor (Debug Logs)"]
    end

    DIO_EXEC --> InterceptorStack
    InterceptorStack --> NETWORK_SEND["إرسال عبر الشبكة لخادم Mattermost"]

    NETWORK_SEND -->|استجابة ناجحة 200/201| SUCCESS["ApiSuccess(fromJson(data))"]
    NETWORK_SEND -->|خطأ DioException| MAP_ERR["_mapDioError()"]
    MAP_ERR -->|تحويل الخطأ| FAIL["ApiFailure(ApiError)"]
```

---

### 3.2 كلاسات `ApiResult` و `ApiError`

#### الوظيفة وآلية العمل:
* `ApiResult<T>`: فئة مغلقة (Sealed) تمثل إما `ApiSuccess<T>` محتوية على البيانات المكتملة، أو `ApiFailure<T>` محتوية على الكائن `ApiError`.
* `ApiError`: تسلسل صريح لكافة حالات الفشل التشغيلي (مثل `NetworkError`, `AuthError`, `ValidationError`, `PermissionError`, `ResourceError`, `FeatureError`, `ServerError`, `UnknownError`).

#### مخطط تدفق البيانات (DataFlow):

```mermaid
flowchart LR
    API_RESPONSE["استجابة ApiClient"] --> CHK{"هل الطلب ناجح؟"}
    CHK -->|نعم| SUC["ApiSuccess<T>(data)"]
    CHK -->|لا| ERR["ApiFailure<T>(ApiError)"]
    
    subgraph ErrorTypes ["أنواع الأخطاء (ApiError Subclasses)"]
        ERR --> NET["NetworkError (الانقطاع والمهلة)"]
        ERR --> AUT["AuthError (401 Unauthorized)"]
        ERR --> VAL["ValidationError (400 Bad Request)"]
        ERR --> PERM["PermissionError (403 Forbidden)"]
        ERR --> RES["ResourceError (404 Not Found)"]
        ERR --> FEAT["FeatureError (501 Disabled Feature)"]
        ERR --> SRV["ServerError (500 Internal Error)"]
    end

    SUC --> UI_REP["معالجة النجاح في BLoC/Repository"]
    ErrorTypes --> UI_REP_ERR["عرض التنبيه المناسب في UI"]
```

---

### 3.3 كلاس `ConnectivityMonitor`

#### الوظيفة وآلية العمل:
* يراقب حالة الشبكة المحلية للجهاز باستخدام مكتبة `connectivity_plus`.
* ينفذ فحص توصيل مباشر عبر `Socket.connect` بالـ IP والمنفذ المخصص لخادم Mattermost لضمان عمل التطبيق في شبكات الـ LAN المغلقة التي لا تمتلك وصولاً للإنترنت الخارجي.
* يضخ التغييرات عبر التدفق `connectionChangeStream`.

#### مخطط تدفق البيانات (DataFlow):

```mermaid
flowchart TD
    INIT["التهيأة والبدء (onConnectivityChanged)"] --> CHECK_CONN["checkConnectivity()"]
    CHECK_CONN --> HAS_NET{"هل يوجد منفذ شبكة؟"}
    HAS_NET -->|لا| OFF["_hasConnection = false"]
    HAS_NET -->|نعم| SOCKET["اختبار التوصيل Socket.connect(host, port)"]
    
    SOCKET -->|نجاح الاتصال بالخادم| ON["_hasConnection = true"]
    SOCKET -->|فشل التوصيل / مهلة 3 ثوانٍ| OFF

    ON --> STREAM["_connectionChangeController.add(true)"]
    OFF --> STREAM["_connectionChangeController.add(false)"]
```

---

### 3.4 كلاس `ServerManager` و `SessionController`

#### الوظيفة وآلية العمل:
* `ServerManager`: مسؤول عن التبديل بين سيرفرات Mattermost المختلفة وتحديث رابط الـ `baseUrl` في الـ `ApiClient` صراحةً.
* `SessionController`: يمثل الوسيط الإشاري لإدارة دورة حياة الجلسة، وبث أحداث مثل انتهاء صلاحية التوكن `SessionEvent.expired` لإعادة توجيه المستخدم لصفحة الدخول.

#### مخطط تدفق البيانات (DataFlow):

```mermaid
flowchart LR
    subgraph ServerMgr ["ServerManager"]
        SW["switchServer(url)"] --> UPD["ApiClient.updateBaseUrl(url)"]
    end

    subgraph SessionCtrl ["SessionController"]
        EXP["AuthInterceptor (401 Error)"] --> EMIT["SessionController.emit(SessionEvent.expired)"]
        EMIT --> STRM["SessionController.stream"]
        STRM --> BLOC["Auth BLoC -> Logout & Clear Storage"]
    end
```

---

### 3.5 كلاس `WebSocketClientManager` (الـ Hub الرئيسي)

#### الوظيفة وآلية العمل:
* يتصل بالمسار الرئيسي `/api/v4/websocket` مع دعم التشفير وحفظ الـ `connection_id` و `sequence_number`.
* يرسل تحديات المصادقة `authentication_challenge` فور فتح الاتصال.
* يراقب النبضات الدوري (Ping/Pong Heartbeat) للتأكد من حيوية القناة.
* يحلل الأحداث القادمة ويحظر تكرار الأحداث عبر الـ Sequence Tracking ويحولها إلى كائنات مطبوعة (`PostCreatedEvent`, `CallStartedEvent`, `ChannelUpdatedEvent`, إلخ).

#### مخطط تدفق البيانات (DataFlow):

```mermaid
flowchart TD
    CONN["connect()"] --> WS_OPEN["فتح WebSocket Connection"]
    WS_OPEN --> AUTH["إرسال authentication_challenge"]
    WS_OPEN --> HEARTBEAT["بدء مؤقت Ping/Pong (15s)"]

    WS_OPEN --> RCV["استقبال الرسالة الخام (jsonDecode)"]
    RCV --> SEQ_CHK{"هل seq مطابقة أو فجوة؟"}
    SEQ_CHK -->|فجوة تسلسل| GAP_EVT["بث WebSocketSequenceGapEvent -> Trigger DeltaSync"]
    SEQ_CHK -->|مطابقة| TYPER["مُحلل الأحداث المطبّعة (Typed Event Parser)"]

    TYPER -->|posted| E1["PostCreatedEvent"]
    TYPER -->|custom_com.mattermost.calls_*| E2["CallStartedEvent / CallEndedEvent"]
    TYPER -->|channel_viewed| E3["ChannelViewedEvent"]

    E1 --> BROADCAST["StreamController<TypedWebSocketEvent>.broadcast"]
    E2 --> BROADCAST
    E3 --> BROADCAST
```

---

### 3.6 متلقفات الشبكة (Interceptors: Auth, Connectivity, Retry)

#### الوظيفة وآلية العمل:
* `AuthInterceptor`: يقرأ الـ Token و Cookies من `SecureStorageService` ويحظر إرفاقها لطلبات التسجيل المفتوحة مثل `/api/v4/users/login`.
* `ConnectivityInterceptor`: يرفض الطلب فوراً إذا كان الجهاز في وضع 오فلين بدون شبكة.
* `RetryInterceptor`: يعيد إرسال الطلبات التي تفشل بأخطاء شبكة مؤقتة أو أخطاء الخادم `500, 502, 503, 504` حتى 3 محاولات بتأخير عشوائي تصاعدي (Jitter).

#### مخطط تدفق البيانات (DataFlow):

```mermaid
flowchart TD
    REQ["طلب جديد من Dio"] --> INT_CONN["ConnectivityInterceptor"]
    INT_CONN -->|يوجد شبكة| INT_AUTH["AuthInterceptor"]
    INT_CONN -->|لا يوجد شبكة| REJ["رفض الطلب بـ DioException.connectionError"]

    INT_AUTH -->|إضافة Headers / Token| SEND["إرسال الطلب للخادم"]

    SEND -->|نجاح الاستجابة| RET["إعادة النتيجة للـ ApiClient"]
    SEND -->|فشل الاستجابة| INT_RETRY["RetryInterceptor"]

    INT_RETRY -->|500/502/503/504 أو Network Timeout| RETRY_CHK{"المحاولات < 3؟"}
    RETRY_CHK -->|نعم| DELAY["حساب التأخير Exponential Backoff + Jitter"]
    DELAY --> SEND
    RETRY_CHK -->|لا| FAIL_ERR["إعادة الخطأ النهائي"]

    INT_RETRY -->|401 Unauthorized| EXPIRE["AuthInterceptor: SessionController.emit(expired)"]
```

---

## 4. المخطط الشامل لمعمارية وتدفق بيانات الشبكة (Unified Network DataFlow)

```mermaid
sequenceDiagram
    autonumber
    actor UI as الواجهة (UI / BLoC)
    participant Repo as Repository
    participant Api as ApiClient
    participant AuthInt as AuthInterceptor
    participant RetryInt as RetryInterceptor
    participant Server as Mattermost Server
    participant WS as WebSocketClientManager

    Note over UI,WS: 1. تنفيذ طلبات REST API
    UI->>Repo: طلب بيانات (مثل fetchPosts)
    Repo->>Api: get('/api/v4/channels/.../posts')
    Api->>AuthInt: تطبيق التوكن والـ CSRF
    AuthInt->>RetryInt: تمرير الطلب المحضر
    RetryInt->>Server: إرسال HTTP GET

    alt استجابة ناجحة (200 OK)
        Server-->>Api: HTTP 200 + Data
        Api-->>Repo: ApiSuccess(PostListDto)
        Repo-->>UI: PostListEntity
    else خطأ في المصادقة (401 Unauthorized)
        Server-->>AuthInt: HTTP 401 Unauthorized
        AuthInt->>SessionController: emit(SessionEvent.expired)
        AuthInt-->>Api: ApiFailure(AuthError)
    else خطأ مؤقت في السيرفر (502 Bad Gateway)
        Server-->>RetryInt: HTTP 502
        RetryInt->>RetryInt: Wait (Backoff + Jitter) & Retry
        RetryInt->>Server: Re-send HTTP GET
    end

    Note over UI,WS: 2. استقبال الأحداث المباشرة (Realtime Events)
    Server-->>WS: WebSocket JSON (posted / call_start)
    WS->>WS: Parse Event & Validate Sequence
    WS-->>UI: TypedWebSocketEvent (PostCreatedEvent)
```
