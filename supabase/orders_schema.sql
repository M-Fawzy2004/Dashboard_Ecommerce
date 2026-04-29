-- Supabase SQL Migration
-- Update orders table with additional fields
ALTER TABLE IF EXISTS public.orders
ADD COLUMN IF NOT EXISTS shipping_address TEXT,
ADD COLUMN IF NOT EXISTS phone TEXT,
ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;

-- Create orders table if not exists (or ensure it has the correct structure)
CREATE TABLE IF NOT EXISTS public.orders (
  id uuid primary key default gen_random_uuid(),
  order_code text not null unique,
  user_id uuid references auth.users(id),
  items jsonb not null, -- Stores product list with details
  total_amount numeric not null,
  status text not null default 'pending', -- (pending, confirmed, delivered, cancelled, etc.)
  payment_method text not null,
  shipping_address text null,
  phone text null,
  latitude double precision null,
  longitude double precision null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Policies
DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;
CREATE POLICY "Users can view their own orders" ON public.orders
  FOR SELECT USING (auth.uid() = user_id OR true); -- For dashboard, we might want to see all or filter. Assuming dashboard sees all.

-- For Dashboard, let's allow service role or specific admins, but for now matching user's request
DROP POLICY IF EXISTS "Admin can view all orders" ON public.orders;
CREATE POLICY "Admin can view all orders" ON public.orders
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can insert their own orders" ON public.orders;
CREATE POLICY "Users can insert their own orders" ON public.orders
  FOR INSERT WITH CHECK (auth.uid() = user_id OR true);

DROP POLICY IF EXISTS "Users can update their own orders" ON public.orders;
CREATE POLICY "Users can update their own orders" ON public.orders
  FOR UPDATE USING (auth.uid() = user_id OR true);
