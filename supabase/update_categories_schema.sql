-- 1. Update product_categories table schema to support full configuration
ALTER TABLE public.product_categories 
  ADD COLUMN IF NOT EXISTS icon_name text null,
  ADD COLUMN IF NOT EXISTS show_sizes boolean not null default false,
  ADD COLUMN IF NOT EXISTS show_colors boolean not null default false,
  ADD COLUMN IF NOT EXISTS show_storage_options boolean not null default false,
  ADD COLUMN IF NOT EXISTS show_ram boolean not null default false,
  ADD COLUMN IF NOT EXISTS show_screen_size boolean not null default false,
  ADD COLUMN IF NOT EXISTS show_processor boolean not null default false,
  ADD COLUMN IF NOT EXISTS show_energy_rating boolean not null default false,
  ADD COLUMN IF NOT EXISTS show_material boolean not null default false,
  ADD COLUMN IF NOT EXISTS size_options jsonb null default '[]',
  ADD COLUMN IF NOT EXISTS brand_options jsonb null default '[]';

-- Enable RLS for categories
ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;

-- Add policies for public access (adapt if you have auth)
DROP POLICY IF EXISTS "Public select categories" ON public.product_categories;
CREATE POLICY "Public select categories" ON public.product_categories FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public insert categories" ON public.product_categories;
CREATE POLICY "Public insert categories" ON public.product_categories FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Public update categories" ON public.product_categories;
CREATE POLICY "Public update categories" ON public.product_categories FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public delete categories" ON public.product_categories;
CREATE POLICY "Public delete categories" ON public.product_categories FOR DELETE USING (true);

-- 2. Decouple products from categories (Remove strict foreign key as requested)
ALTER TABLE public.products DROP CONSTRAINT IF EXISTS products_category_id_fkey;

-- 3. Ensure category_id type is text
ALTER TABLE public.products ALTER COLUMN category_id TYPE text;

-- 4. Insert/Update default categories with full configuration
INSERT INTO public.product_categories (key, name, icon_name, show_sizes, show_colors, show_storage_options, show_ram, show_screen_size, show_processor, show_energy_rating, show_material, size_options, brand_options)
VALUES 
  ('womens_fashion', 'Women''s Fashion', 'woman_2_rounded', true, true, false, false, false, false, false, true, '["XS", "S", "M", "L", "XL", "2XL", "3XL"]', '["Zara", "H&M", "SHEIN", "Mango", "LC Waikiki", "Other"]'),
  ('mens_fashion', 'Men''s Fashion', 'man_2_rounded', true, true, false, false, false, false, false, true, '["XS", "S", "M", "L", "XL", "2XL", "3XL"]', '["Zara", "H&M", "Polo", "Pull&Bear", "LC Waikiki", "Other"]'),
  ('mobile', 'Smartphones', 'smartphone_rounded', false, true, true, true, false, false, false, false, '[]', '["Apple", "Samsung", "Xiaomi", "OPPO", "Vivo", "Huawei", "Nokia", "Other"]'),
  ('tablet', 'Tablets', 'tablet_rounded', false, true, true, true, true, false, false, false, '[]', '["Apple", "Samsung", "Huawei", "Lenovo", "Amazon", "Other"]'),
  ('electronics', 'Electronics', 'electrical_services_rounded', false, false, false, false, false, false, false, false, '[]', '["Sony", "LG", "Philips", "JBL", "Bose", "Other"]'),
  ('laptop', 'Laptops', 'laptop_mac_rounded', false, true, true, true, true, true, false, false, '[]', '["Apple", "Dell", "HP", "Lenovo", "ASUS", "MSI", "Acer", "Other"]'),
  ('fashion', 'Fashion & Accessories', 'checkroom_rounded', false, true, false, false, false, false, false, true, '[]', '["Gucci", "Dior", "Chanel", "Coach", "Michael Kors", "Other"]'),
  ('appliances', 'Home Appliances', 'kitchen_rounded', false, true, false, false, false, false, true, false, '[]', '["Samsung", "LG", "Bosch", "Whirlpool", "Philips", "Tefal", "Other"]'),
  ('sports', 'Sports & Fitness', 'sports_soccer_rounded', true, true, false, false, false, false, false, true, '["XS", "S", "M", "L", "XL", "2XL", "36", "38", "40", "42", "44"]', '["Nike", "Adidas", "Puma", "Under Armour", "Reebok", "Other"]')
ON CONFLICT (key) DO UPDATE SET
  name = EXCLUDED.name,
  icon_name = EXCLUDED.icon_name,
  show_sizes = EXCLUDED.show_sizes,
  show_colors = EXCLUDED.show_colors,
  show_storage_options = EXCLUDED.show_storage_options,
  show_ram = EXCLUDED.show_ram,
  show_screen_size = EXCLUDED.show_screen_size,
  show_processor = EXCLUDED.show_processor,
  show_energy_rating = EXCLUDED.show_energy_rating,
  show_material = EXCLUDED.show_material,
  size_options = EXCLUDED.size_options,
  brand_options = EXCLUDED.brand_options;
