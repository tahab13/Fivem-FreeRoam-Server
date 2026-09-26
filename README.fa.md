# 🎮 FreeRoam FiveM Server

[🇬🇧 English](README.md) | **🇮🇷 فارسی**

سرور FiveM FreeRoam کامل با سیستم‌های پایه، مپ‌های اضافه و اسکریپت‌های جانبی.

---

## 📚 فهرست مطالب

- [قابلیت‌ها](#-قابلیت‌ها)
- [دستورات](#-دستورات)
- [راه‌اندازی](#-راه‌اندازی)
- [تنظیمات](#️-تنظیمات)
- [ساختار پروژه](#-ساختار-پروژه)
- [لایسنس](#-لایسنس)

---

## 🧩 قابلیت‌ها

### 🔹 Core Systems

| نام | توضیحات |
|---|---|
| **FreeRoamCore** | تلپورت، اسپاون خودرو، تعمیر، حذف خودرو، زره، ریوایو |
| **SafeZone** | ۲ ناحیه امن با محافظت کامل در برابر دمیج |
| **loadscreen** | صفحه لودینگ سفارشی |
| **playernames** | نمایش نام بازیکنان بالای سر |
| **vMenu** | منوی ادمین قدرتمند (مدیریت بازیکن، خودرو، زمان، آب‌وهوا) |

### 🔹 Maps

| نام | توضیحات |
|---|---|
| **bob74_ipl** | لودر تمام IPLهای GTA Online و DLCها |
| **dubai** | مپ Dubai Highway |

### 🔹 Scripts

| نام | توضیحات |
|---|---|
| **pma-voice** | سیستم VOIP با قابلیت proximity و رادیو |
| **pma-radio** | سیستم رادیو با UI سفارشی |
| **rpemotes** | سیستم انیمیشن کامل (اموت، رقص، حالت راه‌رفتن، حالت چهره) |
| **speedmeter** | اسپیدومتر با استایل Forza Horizon 4 |
| **sw-nitro** | سیستم نیترو پیشرفته با افکت‌های بصری |
| **vip_system** | منوی VIP با قابلیت‌های اختصاصی |

---

## 📋 دستورات

### FreeRoamCore

| دستور | عملکرد |
|---|---|
| `tpb`, `tp`, `tpr`, `tpa`, `tpm`, `tpc`, `tp2`, `tp3`, `tpv`, `tps` | تلپورت به لوکیشن‌های از پیش تعیین‌شده |
| `car [model]` | اسپاون خودرو |
| `fix` | تعمیر خودرو |
| `dv` | حذف خودرو |
| `armour` | زره کامل |

### کلیدهای میانبر

| کلید | عملکرد |
|---|---|
| `M` | باز کردن منوی vMenu |
| `F2` | منوی VIP / Noclip (vMenu) |
| `F4` | منوی انیمیشن (rpemotes) |
| `X` | لغو انیمیشن |
| `B` | اشاره کردن |
| `LCTRL` | نشستن |
| `RCTRL` | خزیدن |
| `E` | ریوایو |

---

## 🚀 راه‌اندازی

### پیش‌نیازها

- FiveM Server
- oxmysql (برای vMenu)
- OneSync Infinity

### مراحل نصب

1. پوشه `[FreeRoam]` را بسازید و فایل‌های ریپازیتوری را داخل مسیر `resources/[FreeRoam]` سرور خود کپی کنید.
2. خطوط زیر را به `server.cfg` اضافه کنید:

   ```cfg
   ensure [Core]
   ensure [Maps]
   ensure [Scripts]
   ```

3. سرور را ری‌استارت کنید.

---

## ⚙️ تنظیمات

| بخش | مسیر فایل کانفیگ |
|---|---|
| **FreeRoamCore** | `[Core]/FreeRoamCore/config.lua` — مختصات نقاط تلپورت |
| **SafeZone** | `[Core]/SafeZone/config.lua` — مختصات نواحی امن |

---

## 📦 ساختار پروژه

```
[FreeRoam]/
├── [Core]/              # هسته اصلی
│   ├── FreeRoamCore/
│   ├── SafeZone/
│   ├── loadscreen/
│   ├── playernames/
│   └── vMenu/
├── [Maps]/              # مپ‌ها
│   ├── bob74_ipl/
│   └── dubai/
└── [Scripts]/           # اسکریپت‌های جانبی
    ├── pma-voice/
    ├── pma-radio/
    ├── rpemotes/
    ├── speedmeter/
    ├── sw-nitro/
    └── vip_system/
```

---

## 📄 لایسنس

ساخته شده برای سرورهای **FiveM FreeRoam**
استفاده کنید و لذت ببرید

---

Made by tahab13, just for you, Ziba💙
