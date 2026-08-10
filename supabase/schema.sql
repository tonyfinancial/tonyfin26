-- Tony Financial: ejecutar en Supabase > SQL Editor.
create extension if not exists "uuid-ossp";

create table if not exists public.profiles (
  id uuid primary key references auth.users on delete cascade,
  full_name text,
  role text not null default 'admin' check (role in ('admin','asesor','cobranza')),
  created_at timestamptz not null default now()
);
create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(), full_name text not null, document_id text unique,
  phone text, email text, address text, status text not null default 'activo' check (status in ('activo','inactivo')),
  created_at timestamptz not null default now()
);
create table if not exists public.vehicles (
  id uuid primary key default gen_random_uuid(), make text not null, model text not null, year integer,
  vin text unique, price numeric(12,2) not null check (price >= 0), status text not null default 'disponible'
    check (status in ('disponible','reservado','financiado','vendido')), created_at timestamptz not null default now()
);
create table if not exists public.financings (
  id uuid primary key default gen_random_uuid(), client_id uuid not null references public.clients on delete restrict,
  vehicle_id uuid references public.vehicles on delete set null, principal numeric(12,2) not null check (principal > 0),
  annual_rate numeric(5,2) not null default 0, term_months integer not null check (term_months > 0),
  start_date date not null default current_date, status text not null default 'activo' check (status in ('activo','pagado','cancelado')),
  created_at timestamptz not null default now()
);
create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(), financing_id uuid not null references public.financings on delete cascade,
  amount numeric(12,2) not null check (amount > 0), paid_at date not null default current_date,
  method text not null default 'efectivo', reference text, notes text, created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.clients enable row level security;
alter table public.vehicles enable row level security;
alter table public.financings enable row level security;
alter table public.payments enable row level security;
-- Base para una operación interna: usuarios autenticados acceden a los módulos.
create policy "authenticated access" on public.profiles for all to authenticated using (true) with check (true);
create policy "authenticated access" on public.clients for all to authenticated using (true) with check (true);
create policy "authenticated access" on public.vehicles for all to authenticated using (true) with check (true);
create policy "authenticated access" on public.financings for all to authenticated using (true) with check (true);
create policy "authenticated access" on public.payments for all to authenticated using (true) with check (true);

create or replace function public.create_profile_for_user() returns trigger language plpgsql security definer set search_path = public as $$
begin insert into public.profiles (id, full_name) values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.email)); return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.create_profile_for_user();

create or replace view public.financing_balances as
select f.id, f.client_id, f.vehicle_id, f.principal, coalesce(sum(p.amount), 0) as paid,
       f.principal - coalesce(sum(p.amount), 0) as balance
from public.financings f left join public.payments p on p.financing_id = f.id group by f.id;
