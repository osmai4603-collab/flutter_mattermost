# تحليل جداول وحقول قاعدة بيانات Mattermost Server بالتفصيل

**المستند التكميلي:** دليل شامل لبنية وسكيمة (Schema) جداول وحقول قاعدة البيانات في `mattermost/server`.  
**الملف المستهدف:** `/home/osmsoftwareengineering/StudioProjects/flutter_mattermost/docs/database_tables_and_fields_analysis.md`

---

## 1. المبادئ العامة المعمارية للسكيمة (Core Architectural Principles)

1. **معرفات الكيانات (Primary Keys - Base32 IDs):**
   تستخدم كافة الجداول معرفات نصية بطول 26 حرفاً (`VARCHAR(26)` أو `VARCHAR(128)` للتصنيفات)، ويتم توليدها برمجياً عبر `model.NewId()` لضمان العشوائية وعدم التكرار دون الاعتماد على Auto-Increment DB Identifiers.
2. **الطوابع الزمنية (Epoch Milliseconds):**
   تُخزن جميع حقول التواريخ (`createat`, `updateat`, `deleteat`, `lastpostat`, `editat`, `expiresat`) بأرقام صحيحة من نوع `BIGINT` بنظام Unix Timestamp بالميللي ثانية.
3. **الحذف اللطيف (Soft Delete Pattern):**
   الحقل `deleteat` القيمة `0` تعني أن السجل نشط وموجود، بينما القيمة الأكبر من `0` تُعبر عن وقت حذف السجل دون مسحه فعلياً من قاعدة البيانات.
4. **حقول الخصائص المرنة (JSON/Map Properties):**
   تُخزن الإعدادات والتفضيلات المتقدمة في حقول نصية مثل `props VARCHAR(4000)` أو `notifyprops VARCHAR(2000)` وتتحول كودياً إلى `model.StringMap` أو JSON objects.

---

## 2. التحليل التفصيلي للجداول وحقولها مقسمة حسب الموديولات

---

### الموديول 1: المستخدمون والجلسات والتوثيق (Users & Authentication)

#### 1. جدول `users` (جدول الحسابات الرئيسي)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | المعرف الفريد للمستخدم. |
| `createat` | `BIGINT` | | تاريخ إنشاء الحساب بالميللي ثانية. |
| `updateat` | `BIGINT` | INDEX | تاريخ آخر تعديل للبيانات. |
| `deleteat` | `BIGINT` | INDEX | تاريخ حذف الحساب (0 تعني نشط). |
| `username` | `VARCHAR(64)` | UNIQUE, INDEX | اسم المستخدم الفريد في النظام. |
| `password` | `VARCHAR(128)` | | كلمة المرور المشفرة (Bcrypt Hash). |
| `authdata` | `VARCHAR(128)` | UNIQUE | بيانات التوثيق الخارجي (مثل SAML/LDAP ID). |
| `authservice` | `VARCHAR(32)` | | خدمة التوثيق (gitlab, saml, ldap, google, email). |
| `email` | `VARCHAR(128)` | UNIQUE, INDEX | البريد الإلكتروني للمستخدم. |
| `emailverified` | `BOOLEAN` | | هل تم تأكيد البريد الإلكتروني. |
| `nickname` | `VARCHAR(64)` | INDEX | الاسم المستعار المعروض. |
| `firstname` | `VARCHAR(64)` | INDEX | الاسم الأول. |
| `lastname` | `VARCHAR(64)` | INDEX | اسم العائلة. |
| `roles` | `VARCHAR(256)` | | الأدوار المسندة للمستخدم مقسمة بمسافات (مثل `system_user system_admin`). |
| `props` | `VARCHAR(4000)` | | خصائص مخصصة بتنسيق JSON. |
| `notifyprops` | `VARCHAR(2000)` | | إعدادات الإشعارات (البريد، الصوت، التنبيهات). |
| `lastpasswordupdate`| `BIGINT` | | تاريخ آخر تغيير لكلمة المرور. |
| `failedattempts` | `INTEGER` | | عدد المحاولات الفاشلة لتسجيل الدخول. |
| `locale` | `VARCHAR(5)` | | لغة الواجهة المفضلة (مثل `ar`, `en`). |
| `timezone` | `VARCHAR(256)` | | التوقيت المحلي للمستخدم بتنسيق JSON. |
| `mfaactive` | `BOOLEAN` | | هل التوثيق المتعدد الخطوات مفعّل. |
| `mfasecret` | `VARCHAR(128)` | | مفتاح الـ MFA السري. |
| `position` | `VARCHAR(128)` | | المسمى الوظيفي للمستخدم. |
| `remoteid` | `VARCHAR(26)` | | المعرف التابع لخادم خارجي (في القنوات المشتركة). |

#### 2. جدول `sessions` (جلسات تسجيل الدخول)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الجلسة. |
| `token` | `VARCHAR(26)` | UNIQUE | توكن التوثيق المرسل في الهيدر `MMAUTHTOKEN`. |
| `createat` | `BIGINT` | | تاريخ إنشاء الجلسة. |
| `expiresat` | `BIGINT` | INDEX | تاريخ انتهاء الجلسة. |
| `lastactivityat` | `BIGINT` | INDEX | تاريخ آخر نشاط للجلسة. |
| `userid` | `VARCHAR(26)` | INDEX | معرف المستخدم صاحب الجلسة. |
| `roles` | `VARCHAR(256)` | | الأدوار المنسوخة للجلسة لحظة الدخول. |
| `isoauth` | `BOOLEAN` | | هل الجلسة منشأة عبر OAuth2. |
| `props` | `VARCHAR(1000)` | | بيانات إضافية للجلسة (مثل الـ Platform والـ OS). |
| `deviceid` | `VARCHAR(512)` | INDEX | معرف الهاتف لإشعارات Push (FCM / APNS). |

#### 3. جدول `usertermsofservice` (موافقات شروط الخدمة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `userid` | `VARCHAR(26)` | PRIMARY KEY | معرف المستخدم. |
| `termsofserviceid` | `VARCHAR(26)` | | معرف شروط الخدمة الواجب التوقيع عليها. |
| `createat` | `BIGINT` | | تاريخ الموافقة. |

#### 4. جدول `tokens` (التوكنات المؤقتة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `token` | `VARCHAR(64)` | PRIMARY KEY | النص السري للتوكن. |
| `createat` | `BIGINT` | | تاريخ الإنشاء. |
| `type` | `VARCHAR(64)` | | نوع التوكن (إعادة كلمة المرور، تفعيل البريد). |
| `extra` | `VARCHAR(2048)` | | بيانات إضافية مرافقة للتوكن. |

#### 5. جدول `user_access_tokens` (توكنات الوصول الشخصية PAT)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف التوكن. |
| `token` | `VARCHAR(26)` | UNIQUE | التوكن الفريد للتكاملات والبوتات. |
| `userid` | `VARCHAR(26)` | INDEX | المستخدم المالك للتوكن. |
| `description` | `VARCHAR(512)` | | وصف الغرض من التوكن. |
| `isactive` | `BOOLEAN` | | حالة التوكن (نشط / معطل). |

---

### الموديول 2: فرق العمل (Teams & Membership)

#### 1. جدول `teams` (بيانات الفرق)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الفريق. |
| `createat` | `BIGINT` | | تاريخ إنشاء الفريق. |
| `updateat` | `BIGINT` | INDEX | تاريخ آخر تعديل. |
| `deleteat` | `BIGINT` | INDEX | تاريخ الحذف (0 تعني نشط). |
| `displayname` | `VARCHAR(64)` | | الاسم المعروض للفريق. |
| `name` | `VARCHAR(64)` | UNIQUE, INDEX | اسم الفريق الفريد في الـ URL. |
| `description` | `VARCHAR(255)` | | وصف الفريق. |
| `email` | `VARCHAR(128)` | | بريد الدعم أو التواصل للفريق. |
| `type` | `VARCHAR(1)` | | نوع الفريق (`O` مفتوح، `I` بدعوة فقط). |
| `alloweddomains` | `VARCHAR(500)` | | النطاقات المسموح لها بالانضمام تلقائياً. |
| `inviteid` | `VARCHAR(32)` | | رمز رابط الدعوة المباشرة للفريق. |
| `schemeid` | `VARCHAR(26)` | INDEX | مخطط الصلاحيات المخصص للفريق. |
| `groupconstrained`| `BOOLEAN` | | هل الانضمام محصور بمجموعات AD/LDAP. |

#### 2. جدول `teammembers` (عضوية الفرق)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `teamid` | `VARCHAR(26)` | PK (Composite) | معرف الفريق. |
| `userid` | `VARCHAR(26)` | PK (Composite) | معرف المستخدم. |
| `roles` | `VARCHAR(64)` | | أدوار المستخدم بالفريق (مثل `team_user team_admin`). |
| `deleteat` | `BIGINT` | INDEX | تاريخ المغادرة أو الإزالة. |
| `schemeuser` | `BOOLEAN` | | هل يمتلك دور المستخدم الافتراضي بالمخطط. |
| `schemeadmin` | `BOOLEAN` | | هل يمتلك دور المسؤول بالمخطط. |
| `schemeguest` | `BOOLEAN` | | هل المستخدم ضيف (Guest). |

---

### الموديول 3: القنوات وعضويتها (Channels & Membership)

#### 1. جدول `channels` (بيانات القنوات)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف القناة. |
| `createat` | `BIGINT` | | تاريخ الإنشاء. |
| `updateat` | `BIGINT` | INDEX | تاريخ آخر تحديث. |
| `deleteat` | `BIGINT` | INDEX | تاريخ الحذف (0 تعني نشطة). |
| `teamid` | `VARCHAR(26)` | INDEX | معرف الفريق التابعة له القناة. |
| `type` | `VARCHAR(1)` | INDEX | نوع القناة (`O` عامة، `P` خاصة، `D` مباشرة، `G` مجموعة). |
| `displayname` | `VARCHAR(64)` | INDEX | الاسم المعروض للقناة. |
| `name` | `VARCHAR(64)` | UNIQUE(name,teamid) | المعرف النصي الفريد في الـ URL. |
| `header` | `VARCHAR(1024)`| | الترويسة أعلى القناة. |
| `purpose` | `VARCHAR(250)` | | هدف القناة. |
| `lastpostat` | `BIGINT` | INDEX | تاريخ آخر منشور كُتب بالقناة. |
| `totalmsgcount` | `BIGINT` | | إجمالي عدد الرسائل في القناة. |
| `creatorid` | `VARCHAR(26)` | | معرف منشئ القناة. |
| `schemeid` | `VARCHAR(26)` | INDEX | مخطط الصلاحيات المخصص للقناة. |
| `groupconstrained`| `BOOLEAN` | | هل الانضمام محصور بمجموعة LDAP. |
| `shared` | `BOOLEAN` | | هل القناة مشتركة مع خوادم أخرى. |

#### 2. جدول `channelmembers` (عضوية القنوات)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `channelid` | `VARCHAR(26)` | PK (Composite) | معرف القناة. |
| `userid` | `VARCHAR(26)` | PK (Composite), INDEX | معرف المستخدم. |
| `roles` | `VARCHAR(64)` | | أدوار المستخدم بالقناة (مثل `channel_user channel_admin`). |
| `lastviewedat` | `BIGINT` | | تاريخ آخر قراءة للقناة من المستخدم. |
| `msgcount` | `BIGINT` | | عدد الرسائل المنشورة في القناة وقت آخر قراءة. |
| `mentioncount` | `BIGINT` | | عدد الإشارات غير المقروءة (Mentions). |
| `notifyprops` | `VARCHAR(2000)` | | إعدادات التنبيه المخصصة للقناة. |
| `lastupdateat` | `BIGINT` | | تاريخ آخر تحديث للعضوية. |
| `schemeuser` | `BOOLEAN` | | دور مستخدم عادي بالمخطط. |
| `schemeadmin` | `BOOLEAN` | | دور مسؤل قناة بالمخطط. |

#### 3. جدول `channelbookmarks` (الإشارات المرجعية والروابط المثبتة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الإشارة المرجعية. |
| `createat` | `BIGINT` | | تاريخ الإنشاء. |
| `updateat` | `BIGINT` | | تاريخ التعديل. |
| `deleteat` | `BIGINT` | INDEX | تاريخ الحذف. |
| `channelid` | `VARCHAR(26)` | INDEX | القناة التابعة لها الإشارة. |
| `ownerid` | `VARCHAR(26)` | | المستخدم الذي أنشأ الإشارة. |
| `fileid` | `VARCHAR(26)` | | معرف الملف المرتبط إن وجد. |
| `displayname` | `VARCHAR(64)` | | العنوان المعروض للإشارة. |
| `sortorder` | `BIGINT` | | ترتيب الإشارة داخل القناة. |
| `linkurl` | `VARCHAR(2048)`| | الرابط الخارجي المرفق. |
| `type` | `VARCHAR(32)` | | نوع الإشارة (رابط link، ملف file). |

---

### الموديول 4: المنشورات والرسائل والمرفقات (Posts & Messaging)

#### 1. جدول `posts` (الرسائل والمنشورات)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف المنشور. |
| `createat` | `BIGINT` | INDEX | تاريخ كتابة الرسالة. |
| `updateat` | `BIGINT` | INDEX | تاريخ آخر تعديل أو تفاعل. |
| `deleteat` | `BIGINT` | INDEX | تاريخ الحذف (0 تعني نشطة). |
| `userid` | `VARCHAR(26)` | INDEX | كاتب الرسالة. |
| `channelid` | `VARCHAR(26)` | INDEX | القناة التي كتبت فيها الرسالة. |
| `rootid` | `VARCHAR(26)` | INDEX | معرف الرسالة الأصلية في الخيط (Thread Root). |
| `originalid` | `VARCHAR(26)` | INDEX | معرف الرسالة الأصلية قبل التعديل. |
| `message` | `VARCHAR(65535)`| FullText Index | نص الرسالة (يدعم Markdown). |
| `type` | `VARCHAR(26)` | | نوع الرسالة (عادية فارغة، أو نظامية مثل `system_join_channel`). |
| `props` | `VARCHAR(8000)` | | خصائص مخصصة (الرموز المخصصة، المرفقات البصرية). |
| `hashtags` | `VARCHAR(1000)` | FullText Index | التاجات التوضيحية داخل الرسالة. |
| `fileids` | `VARCHAR(300)` | | مصفوفة معرفات الملفات المرفقة بالرسالة. |
| `hasreactions` | `BOOLEAN` | | هل تحتوي الرسالة على تفاعلات Emoji. |
| `editat` | `BIGINT` | | تاريخ آخر تعديل لنص الرسالة. |
| `ispinned` | `BOOLEAN` | INDEX | هل الرسالة مثبته في القناة (Pinned). |

#### 2. جدول `threads` (تتبع خيوط المحادثات CRT)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `postid` | `VARCHAR(26)` | PRIMARY KEY | معرف الرسالة الأصلية للخيط. |
| `channelid` | `VARCHAR(26)` | INDEX | القناة الحاوية للخيط. |
| `lastreplyat` | `BIGINT` | INDEX | تاريخ آخر رد على الخيط. |
| `replycount` | `BIGINT` | | عدد الردود الكلي في الخيط. |
| `participants` | `VARCHAR(4000)` | | قائمة معرفات المشاركين بالخيط. |

#### 3. جدول `reactions` (تفاعلات الإيموجي)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `userid` | `VARCHAR(26)` | PK (Composite) | المستخدم صاحب التفاعل. |
| `postid` | `VARCHAR(26)` | PK (Composite), INDEX | الرسالة المتفاعل عليها. |
| `emojiname` | `VARCHAR(64)` | PK (Composite) | اسم رمز الإيموجي (مثل `thumbsup`). |
| `createat` | `BIGINT` | | تاريخ إضافة التفاعل. |

#### 4. جدول `fileinfo` (تفاصيل المرفقات والملفات)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الملف. |
| `creatorid` | `VARCHAR(26)` | INDEX | رفع الملف بواسطة. |
| `postid` | `VARCHAR(26)` | INDEX | الرسالة المرفق بها الملف. |
| `createat` | `BIGINT` | INDEX | تاريخ رفع الملف. |
| `updateat` | `BIGINT` | | تاريخ التعديل. |
| `deleteat` | `BIGINT` | INDEX | تاريخ حذف الملف. |
| `path` | `VARCHAR(512)` | | المسار الفعلي للملف على القرص أو S3. |
| `thumbnailpath` | `VARCHAR(512)` | | مسار المصغرة (Thumbnail). |
| `previewpath` | `VARCHAR(512)` | | مسار العرض السريع (Preview). |
| `name` | `VARCHAR(256)` | | الاسم الأصلي للملف. |
| `extension` | `VARCHAR(64)` | | امتداد الملف (مثل `pdf`, `png`). |
| `size` | `BIGINT` | | حجم الملف بالبايت. |
| `mime_type` | `VARCHAR(256)` | | نوع الـ MIME للملف. |

---

### الموديول 5: التصنيفات والتفضيلات الجانبية (Sidebar & Preferences)

#### 1. جدول `sidebarcategories` (تصنيفات القائمة الجانبية)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(128)` | PRIMARY KEY | معرف التصنيف. |
| `userid` | `VARCHAR(26)` | INDEX | معرف المستخدم صاحب التصنيف. |
| `teamid` | `VARCHAR(26)` | INDEX | معرف الفريق. |
| `sortorder` | `BIGINT` | | ترتيب التصنيف بالقائمة الجانبية. |
| `sorting` | `VARCHAR(64)` | | وضع ترتيب القنوات داخله (`manual`, `recent`, `alpha`). |
| `type` | `VARCHAR(64)` | | نوع التصنيف (`channels`, `direct_messages`, `favorites`, `custom`, `managed`). |
| `displayname` | `VARCHAR(64)` | | اسم التصنيف المعروض. |
| `muted` | `BOOLEAN` | | هل جميع قنوات التصنيف مكتومة. |
| `collapsed` | `BOOLEAN` | | هل التصنيف مطوي في الواجهة. |

#### 2. جدول `sidebarchannels` (ربط القنوات بالتصنيفات)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `channelid` | `VARCHAR(26)` | PK (Composite) | معرف القناة. |
| `userid` | `VARCHAR(26)` | PK (Composite) | معرف المستخدم. |
| `categoryid` | `VARCHAR(128)` | PK (Composite), INDEX | معرف التصنيف التابع له. |
| `sortorder` | `BIGINT` | | ترتيب القناة داخل التصنيف. |

#### 3. جدول `preferences` (تفضيلات المستخدم العامة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `userid` | `VARCHAR(26)` | PK (Composite), INDEX | معرف المستخدم. |
| `category` | `VARCHAR(32)` | PK (Composite), INDEX | فئة التفضيل (مثل `theme`, `display_settings`). |
| `name` | `VARCHAR(32)` | PK (Composite) | اسم التفضيل المفتاحي. |
| `value` | `VARCHAR(2000)` | | قيمة التفضيل. |

---

### الموديول 6: الأدوار والمخططات والتحكم بالوصول (Roles, Schemes & Access Control)

#### 1. جدول `roles` (تعريف الأدوار والصلاحيات)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الدور. |
| `name` | `VARCHAR(64)` | UNIQUE | الاسم الفريد للدور (مثل `system_admin`, `team_user`). |
| `displayname` | `VARCHAR(128)` | | الاسم المعروض للدور. |
| `description` | `VARCHAR(1024)`| | وصف مهام وصلاحيات الدور. |
| `createat` | `BIGINT` | | تاريخ الإنشاء. |
| `updateat` | `BIGINT` | | تاريخ التعديل. |
| `deleteat` | `BIGINT` | | تاريخ الحذف. |
| `permissions` | `TEXT / VARCHAR`| | قائمة معرّفات الصلاحيات الممنوحة مقسمة بمسافات. |
| `schememanaged` | `BOOLEAN` | | هل الدور مُدار عبر مخطط صلاحيات Scheme. |
| `builtin` | `BOOLEAN` | | هل الدور مدمج أصلياً بالأنظام (System Built-In). |
| `schemeid` | `VARCHAR(26)` | INDEX | المخطط التابع له الدور إن وجد. |

#### 2. جدول `schemes` (مخططات الصلاحيات المخصصة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف المخطط. |
| `name` | `VARCHAR(64)` | UNIQUE | اسم المخطط الفريد. |
| `displayname` | `VARCHAR(128)` | | الاسم المعروض للمخطط. |
| `description` | `VARCHAR(1024)`| | الوصف الفني للمخطط. |
| `scope` | `VARCHAR(32)` | | نطاق تطبيق المخطط (`team` أو `channel`). |
| `defaultteamuserrole` | `VARCHAR(64)` | | الدور الافتراضي للمستخدم بالفريق. |
| `defaultteamadminrole` | `VARCHAR(64)` | | الدور الافتراضي المسؤول بالفريق. |
| `defaultchanneluserrole`| `VARCHAR(64)` | | الدور الافتراضي للمستخدم بالقناة. |
| `defaultchanneladminrole`| `VARCHAR(64)`| | الدور الافتراضي للمسؤول بالقناة. |

---

### الموديول 7: المجموعات ودليل LDAP (Enterprise Groups)

#### 1. جدول `usergroups` (المجموعات المخصصة ومجموعات LDAP)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف المجموعة. |
| `name` | `VARCHAR(64)` | UNIQUE | اسم المجموعة الفريد. |
| `displayname` | `VARCHAR(128)` | | اسم المجموعة المعروض في الواجهة. |
| `description` | `VARCHAR(1024)`| | وصف المجموعة. |
| `source` | `VARCHAR(64)` | | مصدر المجموعة (`ldap` أو `custom`). |
| `remoteid` | `VARCHAR(48)` | UNIQUE | المعرف الخاص بها في سيرفر الـ AD/LDAP. |
| `allowreference` | `BOOLEAN` | | هل يُسمح بالإشارة للمجموعة بـ `@groupname`. |

#### 2. جدول `groupmembers` (أعضاء المجموعات)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `groupid` | `VARCHAR(26)` | PK (Composite) | معرف المجموعة. |
| `userid` | `VARCHAR(26)` | PK (Composite), INDEX | معرف المستخدم العضو. |
| `createat` | `BIGINT` | | تاريخ الإضافة للمجموعة. |

---

### الموديول 8: البوتات والتكاملات (Bots & Integrations)

#### 1. جدول `bots` (حسابات البوتات)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `userid` | `VARCHAR(26)` | PRIMARY KEY | معرف حساب المستخدم المخصص كـ Bot. |
| `description` | `VARCHAR(1024)`| | وصف وظيفة البوت. |
| `ownerid` | `VARCHAR(26)` | INDEX | معرف المستخدم المالك والمشرف على البوت. |

#### 2. جدول `incomingwebhooks` (الـ Webhooks الواردة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الـ Webhook. |
| `userid` | `VARCHAR(26)` | | معرف المنشئ. |
| `channelid` | `VARCHAR(26)` | | القناة المستهدفة بنشر الرسائل. |
| `teamid` | `VARCHAR(26)` | | الفريق التابع له الـ Webhook. |
| `name` | `VARCHAR(64)` | | اسم الـ Webhook. |

#### 3. جدول `commands` (أوامر السلاش Slash Commands)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الأمر. |
| `token` | `VARCHAR(26)` | | توكن التفويض الخاص بالأمر. |
| `trigger` | `VARCHAR(128)` | INDEX | الكلمة التي تفعل الأمر (مثل `/poll`). |
| `url` | `VARCHAR(1024)`| | رابط الـ Endpoint الخارجي الذي يستقبل الأمر. |
| `method` | `VARCHAR(1)` | | نوع الطلب (`P` لـ POST أو `G` لـ GET). |

---

### الموديول 9: الامتثال والسجلات والوظائف (Compliance, Audit & Jobs)

#### 1. جدول `audits` (سجلات التدقيق والمراجعة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف سجل التدقيق. |
| `createat` | `BIGINT` | | تاريخ وقوع الحدث. |
| `userid` | `VARCHAR(26)` | INDEX | المستخدم الذي قام بالعملية. |
| `action` | `VARCHAR(512)` | | اسم العملية المتنفذة (تسجيل دخول، حذف قناة...). |
| `extrainfo` | `VARCHAR(1024)`| | تفاصيل إضافية عن العملية والمحيط. |
| `ipaddress` | `VARCHAR(64)` | | عنوان IP الذي نفذ منه المستخدم الطلب. |

#### 2. جدول `jobs` (الوظائف والخلفية المجدولة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الوظيفة. |
| `type` | `VARCHAR(64)` | INDEX | نوع الوظيفة (فهرسة رسائل، تنظيف ملفات، أرشفة). |
| `priority` | `BIGINT` | | أولوية التنفيذ. |
| `status` | `VARCHAR(32)` | INDEX | حالة الوظيفة (`pending`, `in_progress`, `success`, `error`). |
| `data` | `VARCHAR(1024)`| | بيانات ومدخلات الوظيفة بتنسيق JSON. |

---

### الموديول 10: متغيرات النظام والملخصات (Systems, Recaps & Analytics)

#### 1. جدول `systems` (إعدادات ومتغيرات النظام العامة)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `name` | `VARCHAR(64)` | PRIMARY KEY | اسم المتغير (مثل `Version`, `UpgradedFromVersion`). |
| `value` | `VARCHAR(1024)`| | قيمة المتغير المخزنة. |

#### 2. جدول `licenses` (بيانات تراخيص الخادم)
| اسم الحقل | النوع | القيود | الوصف والشرح |
| :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(26)` | PRIMARY KEY | معرف الترخيص. |
| `createat` | `BIGINT` | | تاريخ تفعيل الترخيص. |
| `bytes` | `TEXT` | | نص مفتاح الترخيص المشتري المشفر. |

---

## 3. الخلاصة
تتميز السكيمة الخاصة بـ Mattermost بالصيانة العالية وقوة الفهرسة (Indexing) على جميع حقول البحث والتعديل الحساسة (`updateat`, `createat`, `deleteat`) لتوفير استجابة فورية فائقة السرعة على الخوادم ذات الأحجام الملايينية من الرسائل والمستخدمين.
