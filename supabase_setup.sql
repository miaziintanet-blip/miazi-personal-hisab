-- Miazi Personal Hisab: run this in the NEW project's Supabase SQL Editor.
-- This creates only a new table and policies. It does not alter existing tables.
create table if not exists public.personal_entries (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('income','expense')),
  amount numeric(14,2) not null check (amount > 0),
  category text not null default '',
  note text not null default '',
  entry_date date not null default current_date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.personal_entries enable row level security;

drop policy if exists "Users can view their own personal entries" on public.personal_entries;
create policy "Users can view their own personal entries"
on public.personal_entries for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own personal entries" on public.personal_entries;
create policy "Users can insert their own personal entries"
on public.personal_entries for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own personal entries" on public.personal_entries;
create policy "Users can update their own personal entries"
on public.personal_entries for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own personal entries" on public.personal_entries;
create policy "Users can delete their own personal entries"
on public.personal_entries for delete to authenticated
using (auth.uid() = user_id);

grant select, insert, update, delete on public.personal_entries to authenticated;
