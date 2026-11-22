
create extension if not exists pgcrypto;

create table public.children (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  full_name text not null,
  birth_date date,
  avatar_url text,
  created_at timestamptz default now()
);

create table public.media (
  id uuid primary key default gen_random_uuid(),
  child_id uuid not null references public.children(id) on delete cascade,
  storage_path text not null,
  original_filename text not null,
  media_type text not null,
  captured_at date,
  original_exif_date timestamptz,
  date_source text default 'unknown',
  manual_override boolean default false,
  created_at timestamptz default now()
);

create table public.events (
  id uuid primary key default gen_random_uuid(),
  child_id uuid not null references public.children(id) on delete cascade,
  title text not null,
  description text,
  start_date date,
  end_date date,
  category text
);

create table public.event_media (
  event_id uuid references public.events(id) on delete cascade,
  media_id uuid references public.media(id) on delete cascade,
  sort_order integer default 0,
  primary key(event_id, media_id)
);

create table public.journals (
  id uuid primary key default gen_random_uuid(),
  child_id uuid not null references public.children(id) on delete cascade,
  title text not null,
  content text,
  memory_date date,
  created_at timestamptz default now()
);

create table public.movies (
  id uuid primary key default gen_random_uuid(),
  child_id uuid not null references public.children(id) on delete cascade,
  title text not null,
  start_date date,
  end_date date,
  style text default 'mix',
  status text default 'draft',
  output_path text
);

create table public.movie_media (
  movie_id uuid references public.movies(id) on delete cascade,
  media_id uuid references public.media(id) on delete cascade,
  sort_order integer default 0,
  duration_seconds numeric default 4,
  transition text default 'fade',
  primary key(movie_id, media_id)
);
