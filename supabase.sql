-- RusWay database schema. Run in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 full_name text, role text not null default 'student' check(role in ('student','admin')),
 created_at timestamptz default now()
);
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into public.profiles(id,full_name) values(new.id,coalesce(new.raw_user_meta_data->>'full_name','')); return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.profiles where id=auth.uid() and role='admin'); $$;
create table if not exists public.courses(id uuid primary key default gen_random_uuid(),title text not null,level text not null check(level in ('A1','A2','B1','B2','C1')),description text default '',created_by uuid references auth.users(id),created_at timestamptz default now());
create table if not exists public.lessons(id uuid primary key default gen_random_uuid(),course_id uuid references public.courses(id) on delete cascade,title text not null,content text default '',created_by uuid references auth.users(id),created_at timestamptz default now());
create table if not exists public.exams(id uuid primary key default gen_random_uuid(),title text not null,description text default '',question_count int default 50,created_by uuid references auth.users(id),created_at timestamptz default now());
create table if not exists public.questions(id uuid primary key default gen_random_uuid(),exam_id uuid not null references public.exams(id) on delete cascade,question_text text not null,option_a text not null,option_b text not null,option_c text not null,option_d text not null,correct_answer text not null,created_at timestamptz default now());
create table if not exists public.attempts(id uuid primary key default gen_random_uuid(),student_id uuid not null references auth.users(id),exam_id uuid not null references public.exams(id),total_questions int not null,correct_answers int not null,score_percent int not null,answers jsonb default '{}',created_at timestamptz default now());
alter table public.profiles enable row level security;
alter table public.courses enable row level security; alter table public.lessons enable row level security; alter table public.exams enable row level security; alter table public.questions enable row level security; alter table public.attempts enable row level security;
create policy "profiles read self or admin" on public.profiles for select using(id=auth.uid() or public.is_admin());
create policy "admin update profiles" on public.profiles for update using(public.is_admin()) with check(public.is_admin());
create policy "profile insert self" on public.profiles for insert with check(id=auth.uid());
create policy "courses visible" on public.courses for select to authenticated using(true);
create policy "admin manage courses" on public.courses for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "lessons visible" on public.lessons for select to authenticated using(true);
create policy "admin manage lessons" on public.lessons for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "exams visible" on public.exams for select to authenticated using(true);
create policy "admin manage exams" on public.exams for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "questions visible" on public.questions for select to authenticated using(true);
create policy "admin manage questions" on public.questions for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "student read own attempts" on public.attempts for select to authenticated using(student_id=auth.uid() or public.is_admin());
create policy "student create own attempts" on public.attempts for insert to authenticated with check(student_id=auth.uid());
create policy "admin manage attempts" on public.attempts for all to authenticated using(public.is_admin()) with check(public.is_admin());
-- IMPORTANT: After signing up your account, promote it to admin manually in SQL Editor:
-- update public.profiles set role='admin' where id=(select id from auth.users where email='YOUR_EMAIL');
