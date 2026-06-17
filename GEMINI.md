# AutoWay Loyihasi: Texnik Talablar va Qonun-Qoidalar

Ushbu hujjat loyihada ishtirok etadigan barcha dasturchilar (va men - Gemini CLI) uchun majburiy hisoblanadi. Har bir yangi funksiya yoki o'zgarish quyidagi qoidalarga 100% mos kelishi shart.

## 1. Arxitektura Qoidalari (Clean Architecture)
Loyiha **Feature-first Clean Architecture** asosida quriladi.
- **Layers (Qatlamlar):** Har bir feature `data`, `domain`, va `presentation` qatlamlariga ega bo'lishi shart.
- **Independence (Mustaqillik):** Presentation qatlami Data qatlamini tanimasligi kerak. Ular faqat Domain qatlami (Entities, Repositories) orqali bog'lanadi.
- **Core:** Barcha umumiy mantiq (Theme, Network, Error handling) faqat `lib/core` ichida bo'lishi shart.

## 2. UI va Dizayn Talablari (Figma Strictness)
- **Design Tokens:** Ranglar faqat `AppColors` va matn stillari faqat `AppText` klasslaridan olinishi shart. "Hardcoded" rang yoki shrift o'lchamlarini ishlatish taqiqlanadi.
- **Figma Fidelity:** Dizayn Figma'da qanday bo'lsa (padding, border-radius, shadows), Flutter'da ham 1:1 bir xil bo'lishi shart.
- **Responsiveness:** Ilova turli xil ekran o'lchamlariga (iPhone SE dan tortib iPhone 15 Pro Max gacha) moslashuvchan bo'lishi kerak.

## 3. Kodlash Standartlari
- **Naming:** Fayl nomlari `snake_case`, klass nomlari `PascalCase`, o'zgaruvchilar va metodlar `camelCase` formatida bo'lishi shart.
- **Clean Code:** Har bir metod 20 qatordan, har bir fayl 200 qatordan oshmasligi tavsiya etiladi. Murakkab widgetlarni kichikroq "Private Widgets"ga bo'lish shart.
- **Null Safety:** Dart-ning null-safety imkoniyatlaridan maksimal darajada foydalanish, `!` belgisini ishlatmaslikka harakat qilish.

## 4. State Management (BLoC & Cubit Hybrid)
- Loyihada **flutter_bloc** kutubxonasidan foydalaniladi.
- **Cubit:** Oddiy holat o'zgarishlari va CRUD amallari uchun (masalan: Profile loading, Settings).
- **BLoC:** Murakkab mantiqiy jarayonlar, event-larni transformatsiya qilish (debounce, throttle) yoki murakkab oqimlar (streams) bilan ishlash uchun (masalan: Real-time map tracking, Search autocomplete).
- Har qanday holatda ham State-lar **Freezed** orqali yaratilishi shart (Union types).

## 5. Ma'lumotlar Modellari (Freezed)
- Barcha Data Model va Domain Entity-lar **Freezed** va **json_serializable** yordamida yaratilishi shart.
- Immutability qoidalariga qat'iy rioya qilinadi.

## 6. Tarmoq Qatlami (Dio)
- Tarmoq so'rovlari uchun **Dio** kutubxonasi ishlatiladi.
- `lib/core/network` ichida markazlashgan `DioClient` yaratilib, unga `Interceptors` (Logging, Auth, Error handling) qo'shilishi shart.
- So'rovlar natijasi `Either<Failure, Success>` formatida qaytariladi.


## 7. Texnik Optimallashtirish va Hujjatlashtirish (Rationale)
- Har bir muhim texnik qaror (masalan, Image Cache limitlarini oshirish, murakkab algoritmlar) kod ichida batafsil izoh bilan kelishi shart.
- Izohlar faqat "nima" qilinayotganini emas, balki "nega" qilinayotganini (Rationale) tushuntirishi kerak.
- Performance (unumdorlik) loyihaning ajralmas qismi hisoblanadi. Xotira bilan ishlash, CPU yuklamasi va batareya sarfi har doim hisobga olinadi.

## 8. Xarita va Lokatsiya (Yandex Maps)
- Loyihada xarita bilan ishlash uchun faqat **yandex_mapkit_lite** kutubxonasi ishlatiladi.
- Xaritadagi barcha markerlar, marshrutlar (routes) va qidiruv (search) mantiqlari Yandex API orqali amalga oshiriladi.
- Xaritada foydalanuvchi va haydovchi o'rtasidagi real-time masofani hisoblashda Yandex-ning maxsus algoritmlaridan foydalaniladi.
