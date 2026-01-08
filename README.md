<div align="center">

<img src="logo.png" width="120"/>

# 📊 FAB HESABAT

### FAB Şirkətlər Qrupu üçün Analitik Hesabat Paneli

Streamlit üzərindən hazırlanmış bu tətbiq satış, sifariş, borc və qırmızı göstəricilərin  
**günlük və aylıq** əsasda **vizual və cəmlənmiş** formada təqdim edilməsi üçün nəzərdə tutulmuşdur.

---

![Streamlit](https://img.shields.io/badge/Streamlit-App-red?logo=streamlit)
![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python)
![Status](https://img.shields.io/badge/Status-Active-success)

</div>

---

## 🚀 Funksionallıq

Bu tətbiq aşağıdakı hesabatları avtomatik olaraq yaradır:

### 📌 Hesabat Bölmələri
- **Günlük**
  - Günlük Satış
  - Günlük Sifariş
- **Satış**
  - SATIŞ
  - PLAN
  - İCRA (%)
- **Sifariş**
- **Borc**
- **Qırmızı**

Hər bölmədə:
- 📈 Avtomatik **CƏM (Total)** hesablanır  
- 🔢 Rəqəmlər minlik ayırıcı ilə formatlanır  
- 🎨 Cəmi sətir xüsusi rənglə vurğulanır  

---

## 🧠 Texniki Xüsusiyyətlər

- 📦 **Streamlit** – interaktiv istifadəçi interfeysi  
- 🐼 **Pandas** – məlumatların emalı  
- 🌐 **REST API** – MSSQL sorğuların icrası  
- 🔐 **Streamlit Secrets** – təhlükəsiz açar idarəetməsi  
- 🎨 **Custom CSS** – fərdiləşdirilmiş dizayn  

---

## 🔗 Məlumat Mənbəyi (API)

**Endpoint:**  
[GetQueryTable API](http://81.17.83.210:1999/api/Metin/GetQueryTable)

Sorğular `.sql` fayllarından oxunur:
- `Hesabat - Satis.sql`
- `Hesabat - Satis - Gunluk.sql`
- `Hesabat - Sifaris.sql`
- `Hesabat - Sifaris - Gunluk.sql`
- `Hesabat - Borc.sql`
- `Hesabat - Qirmizi.sql`

---

## 🔐 Konfiqurasiya

`.streamlit/secrets.toml` faylı:

```toml
Kod = "SIZIN_API_KODUNUZ"
