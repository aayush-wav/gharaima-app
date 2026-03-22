-- USERS (customers)
create table public.users (
  id uuid references auth.users on delete cascade primary key,
  phone text unique not null,
  full_name text,
  profile_photo_url text,
  default_address text,
  default_latitude double precision,
  default_longitude double precision,
  created_at timestamp with time zone default now()
);

-- SERVICE CATEGORIES
create table public.categories (
  id serial primary key,
  name text not null,
  icon_url text,
  description text
);

-- SERVICES (items within a category)
create table public.services (
  id serial primary key,
  category_id integer references public.categories(id),
  name text not null,
  description text,
  base_price numeric not null,
  price_unit text default 'per visit',
  duration_minutes integer,
  image_url text
);

-- SERVICE PROVIDERS
create table public.providers (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  phone text,
  profile_photo_url text,
  bio text,
  category_ids integer[],
  rating numeric default 0,
  total_reviews integer default 0,
  is_available boolean default true,
  latitude double precision,
  longitude double precision
);

-- BOOKINGS
create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references public.users(id),
  provider_id uuid references public.providers(id),
  service_id integer references public.services(id),
  status text default 'pending',
    -- status values: pending, confirmed, in_progress, completed, cancelled
  scheduled_at timestamp with time zone not null,
  address text not null,
  latitude double precision,
  longitude double precision,
  total_price numeric,
  payment_method text default 'cash',
    -- payment_method values: cash, esewa, khalti
  payment_status text default 'unpaid',
  notes text,
  created_at timestamp with time zone default now()
);

-- REVIEWS
create table public.reviews (
  id serial primary key,
  booking_id uuid references public.bookings(id),
  customer_id uuid references public.users(id),
  provider_id uuid references public.providers(id),
  rating integer check (rating >= 1 and rating <= 5),
  comment text,
  created_at timestamp with time zone default now()
);

-- SEED DATA for categories
insert into public.categories (name, description) values
  ('Home Cleaning', 'Professional home and apartment cleaning'),
  ('Plumbing', 'Pipe repairs, installations, and maintenance'),
  ('Electrical', 'Wiring, fixtures, and electrical repairs'),
  ('Beauty & Wellness', 'Haircuts, facials, and wellness services at home');

-- SEED DATA for services
insert into public.services (category_id, name, description, base_price, price_unit, duration_minutes) values
  (1, 'Full Home Cleaning', 'Deep cleaning of entire home', 1500, 'per visit', 180),
  (1, 'Kitchen Cleaning', 'Deep kitchen clean including appliances', 800, 'per visit', 90),
  (1, 'Bathroom Cleaning', 'Thorough bathroom scrub and disinfect', 500, 'per visit', 60),
  (2, 'Pipe Leak Repair', 'Fix leaking pipes and joints', 700, 'per visit', 60),
  (2, 'Tap Installation', 'Install or replace taps and faucets', 500, 'per visit', 45),
  (2, 'Blocked Drain Clearing', 'Clear blocked drains and pipes', 600, 'per visit', 60),
  (3, 'Switchboard Repair', 'Fix faulty switchboards and sockets', 600, 'per visit', 60),
  (3, 'Light Fixture Installation', 'Install ceiling lights and fans', 700, 'per visit', 90),
  (4, 'Haircut at Home', 'Professional haircut at your doorstep', 500, 'per visit', 45),
  (4, 'Full Body Massage', 'Relaxing full body massage at home', 2000, 'per session', 90);

-- SEED DATA for providers (dummy, for MVP testing)
insert into public.providers (full_name, phone, bio, category_ids, rating, total_reviews, latitude, longitude) values
  ('Ram Shrestha', '9841000001', 'Experienced home cleaner with 5 years in Kathmandu', '{1}', 4.8, 42, 27.7172, 85.3240),
  ('Sita Tamang', '9841000002', 'Professional beauty therapist', '{4}', 4.9, 67, 27.7105, 85.3183),
  ('Bikash Karki', '9841000003', 'Licensed electrician, 8 years experience', '{3}', 4.7, 31, 27.7200, 85.3300),
  ('Dilip Rai', '9841000004', 'Plumbing specialist, available 7 days a week', '{2}', 4.6, 28, 27.7150, 85.3220);

-- SUPABASE ROW LEVEL SECURITY (RLS)
-- Enable RLS
alter table public.users enable row level security;
alter table public.bookings enable row level security;
alter table public.reviews enable row level security;

-- Users can only read/update their own profile
create policy "Users can view own profile" on public.users
  for select using (auth.uid() = id);
create policy "Users can update own profile" on public.users
  for update using (auth.uid() = id);
create policy "Users can insert own profile" on public.users
  for insert with check (auth.uid() = id);

-- Anyone logged in can read categories and services
create policy "Public read categories" on public.categories
  for select using (true);
create policy "Public read services" on public.services
  for select using (true);
create policy "Public read providers" on public.providers
  for select using (true);

-- Bookings: customers can only see and create their own
create policy "Customers view own bookings" on public.bookings
  for select using (auth.uid() = customer_id);
create policy "Customers create bookings" on public.bookings
  for insert with check (auth.uid() = customer_id);
create policy "Customers update own bookings" on public.bookings
  for update using (auth.uid() = customer_id);

-- Reviews: customers can create reviews for their own completed bookings
create policy "Customers create reviews" on public.reviews
  for insert with check (auth.uid() = customer_id);
create policy "Public read reviews" on public.reviews
  for select using (true);
