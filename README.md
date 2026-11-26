# RusWay
Rus tilini o‘rganish platformasi (React + Vite + Supabase).

## Ishga tushirish
1. Supabase’da bepul loyiha yarating.
2. SQL Editor’da `supabase.sql` faylini to‘liq bajaring.
3. `.env.example` nusxasini `.env` deb nomlang va Supabase Project URL hamda anon public key kiriting.
4. Terminalda:
   ```bash
   npm install
   npm run dev
   ```
5. Ro‘yxatdan o‘ting. Supabase SQL Editor’da profilingizni admin qiling:
   ```sql
   update public.profiles set role='admin'
   where id=(select id from auth.users where email='SIZNING_EMAIL');
   ```

## Hozirgi imkoniyatlar
- Email/parol orqali ro‘yxatdan o‘tish va kirish
- A1–C1 kurslar va darslar
- Imtihonlar, savol va javob variantlarini aralashtirish
- Natijani hisoblash va urinishni bazaga saqlash
- Admin roli va server tomondagi RLS himoyasi
- Admin kurs/dars/imtihon yaratishi va kurs/imtihonni o‘chirishi

## Muhim, ochiq aytilgan cheklov
Bu — ishga tushiriladigan boshlang‘ich full-stack loyiha, lekin hali yakuniy ishlab chiqarish versiyasi emas. Admin interfeysida savollarni ommaviy import qilish, tahrirlash, talaba bloklash, batafsil statistika va 675 savol bankini import qilish keyingi bosqichda qo‘shiladi. 675 savolning matni sizdan olinmaguncha ularni uydirib to‘ldirmaymiz. Adminni faqat SQL orqali tayinlang; hech qachon brauzerda admin rolini o‘zgartirishga ruxsat bermang.
