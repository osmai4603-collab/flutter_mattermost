# دليل إرشادي: كيفية إضافة وتفعيل Plugin في خادم Mattermost (مثال: Calls Plugin)

## 1. مقدمة

يوضح هذا الدليل الخطوات العملية والتفصيلية لإضافة وتفعيل ملحق (Plugin) في خادم Mattermost Server، استناداً إلى التجربة العملية السابقة في بناء وإضافة **Mattermost Calls Plugin** (`com.mattermost.calls`).

---

## 2. النظرة العامة لهيكلية الـ Plugin في Mattermost

أي ملحق (Plugin) في Mattermost يتكون عادةً من الأجزاء التالية:
- **`plugin.json`**: ملف التعريف للملحق (يحتوي على المعرّف الفريد `id` مثل `com.mattermost.calls` والاسم والنسخة والإعدادات).
- **جزء الخادم (Server Binary)**: ثنائي خفيف بلغة Go مجمع لبيئة التشغيل (مثل `plugin-linux-amd64`).
- **جزء الواجهة (Webapp Bundle)**: كود JavaScript مجمع للواجهة (`dist/main.js`).
- **الحزمة النهائية (Dist Bundle)**: ملف مضغوط بصيغة `.tar.gz` يحتوي كافة المكونات المذكورة أعلاه.

---

## 3. الخطوة الأولى: بناء حزمة الـ Plugin (Build Stage)

قبل تثبيت أي Plugin مخصص أو محلي (مثل `mattermost-plugin-calls`):

1. **استคลون المستودع المستقل للملحق**:
   ```bash
   git clone https://github.com/mattermost/mattermost-plugin-calls.git
   cd mattermost-plugin-calls
   ```

2. **بناء الحزمة المجمعة**:
   ```bash
   make dist
   ```
   *النتيجة*: ينشئ الأمر حزمة مضغوطة جاهزة للنشر داخل مجلد `dist/` باسم:
   `dist/com.mattermost.calls-x.y.z.tar.gz`

---

## 4. طرق تثبيت وإضافة الـ Plugin على خادم Mattermost (Installation Methods)

هناك 4 طرق رئيسية لإضافة وتثبيت الملحق على الخادم:

### الطريقة 1: عبر لوحة التحكم (System Console Upload) - الطريقة الرسمية والأسهل

1. تأكد من تفعيل إمكانية رفع الملحقات في ملف إعدادات الخادم `server/config/config.json`:
   ```json
   "PluginSettings": {
       "Enable": true,
       "EnableUploads": true
   }
   ```
2. افتح لوحة تحكم المسؤول (System Console) في المتصفح:
   `http://localhost:8065/admin_console/plugins/plugin_management`
3. في قسم **Plugin Management**:
   - اضغط على **Choose File** وحدد ملف الـ Plugin المضغوط (`com.mattermost.calls-x.y.z.tar.gz`).
   - اضغط على **Upload**.
4. بعد الرفع، انتقل إلى قسم **Installed Plugins** واضغط على **Enable** لتفعيل الملحق.

---

### الطريقة 2: عبر مجلد الملحقات المسبقة التعبئة (Prepackaged Plugins)

تُستخدم هذه الطريقة عند بناء الخادم أو تشغيله مع الملحقات المضمنة تلقائياً:

1. انسب ملف الـ Plugin إلى مجلد `prepackaged_plugins` داخل مشروع الخادم:
   ```bash
   cp dist/com.mattermost.calls-x.y.z.tar.gz /home/osmsoftwareengineering/mattermost/server/prepackaged_plugins/
   ```
2. (اختياري) إذا كان الخادم مفّعلاً فيه التحقق من التوقيع الرقمي للملحقات (`RequirePluginSignature: true`)، قم بإضافة ملف التوقيع `.tar.gz.sig` بجانبه.
3. عند بدء تشغيل الخادم (`make run-server` أو تشغيل الثنائي)، يكتشف الخادم وجود الملحق تلقائياً ويقوم بفكه وتثبيته وتفعيله.

---

### الطريقة 3: التثبيت اليدوي المباشر بفك الضغط (Manual Folder Extraction)

في البيئات التطويرية المحلية أو عند الرغبة في التثبيت السريع بدون رفع عبر الشبكة:

1. انتقل إلى مجلد الملحقات الرئيسي في الخادم (المحدد في `PluginSettings.Directory` وهو افتراضياً `server/plugins/`):
   ```bash
   cd /home/osmsoftwareengineering/mattermost/server
   mkdir -p plugins/com.mattermost.calls
   ```
2. فك ضغط ملف الـ Plugin داخل المجلد المخصص:
   ```bash
   tar -xzf /path/to/com.mattermost.calls-x.y.z.tar.gz -C plugins/com.mattermost.calls --strip-components=1
   ```
3. عدّل ملف الإعدادات `server/config/config.json` لتفعيل الملحق صراحةً:
   ```json
   "PluginSettings": {
       "Enable": true,
       "PluginStates": {
           "com.mattermost.calls": {
               "Enable": true
           }
       }
   }
   ```
4. أعد تشغيل خادم Mattermost لتطبيق التغييرات.

---

### الطريقة 4: باستخدام أداة السطر الأوامر الرسمية `mmctl` (CLI Tool)

إذا كنت تفضل إدارة الخادم عبر الأوامر السريعة:

```bash
# إضافة الملحق إلى الخادم
mmctl plugin add dist/com.mattermost.calls-x.y.z.tar.gz --local

# تفعيل الملحق
mmctl plugin enable com.mattermost.calls --local

# التحقق من قائمة الملحقات المثبتة وحالتها
mmctl plugin list --local
```

---

## 5. التحقق والاختبار بعد التثبيت (Verification & Troubleshooting)

### 1. التحقق عبر الـ REST API:

يمكنك التأكد من تفعيل الملحق بعمل طلبات الاختبار التالية:
- **فحص حالات الملحقات المثبتة**:
  `GET http://localhost:8065/api/v4/plugins/statuses`
- **فحص ملحقات الواجهة المفعّلة**:
  `GET http://localhost:8065/api/v4/plugins/webapp`
- **فحص مسارات الملحق الخاص (مثال Calls API)**:
  `GET http://localhost:8065/plugins/com.mattermost.calls/config`

### 2. معالجة المشاكل الشائعة (Troubleshooting):

- **خطأ "Plugins are disabled"**: تأكد من ضبط `"Enable": true` في `PluginSettings`.
- **خطأ "Uploads are disabled"**: تأكد من ضبط `"EnableUploads": true` in `PluginSettings`.
- **فشل تشغيل الملحق (Failed to start plugin)**: تحقق من صلاحيات التنفيذ للثنائي الخاص بالخادم داخل `plugins/com.mattermost.calls/server/dist/plugin-linux-amd64` بعمل:
  ```bash
  chmod +x plugins/com.mattermost.calls/server/dist/plugin-linux-amd64
  ```
- **سجلات الخادم (Server Logs)**: راجع سجلات الخادم لمتابعة أخطاء التحميل والتفعيل:
  ```bash
  tail -f /home/osmsoftwareengineering/mattermost/server/logs/mattermost.log | grep plugin
  ```
