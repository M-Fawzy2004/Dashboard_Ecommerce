-- ============================================================
--  product_reviews — Supabase SQL Table
--  Run this in: Supabase Dashboard → SQL Editor
-- ============================================================

CREATE TABLE IF NOT EXISTS public.product_reviews (
  id            UUID                     DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id    TEXT                     NOT NULL,
  user_id       UUID                     NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name     TEXT                     NOT NULL,
  rating        SMALLINT                 NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment       TEXT                     NOT NULL CHECK (char_length(comment) >= 5),
  created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Index ──────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_product_reviews_product_id
  ON public.product_reviews (product_id);

CREATE INDEX IF NOT EXISTS idx_product_reviews_user_id
  ON public.product_reviews (user_id);

-- ── Row Level Security ─────────────────────────────────────────────────────
ALTER TABLE public.product_reviews ENABLE ROW LEVEL SECURITY;

-- Everyone can read reviews
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'reviews_select_all') THEN
        CREATE POLICY "reviews_select_all" ON public.product_reviews FOR SELECT USING (true);
    END IF;
END $$;

-- Only authenticated users can insert their OWN reviews
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'reviews_insert_own') THEN
        CREATE POLICY "reviews_insert_own" ON public.product_reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
END $$;

-- Users can update only their own reviews
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'reviews_update_own') THEN
        CREATE POLICY "reviews_update_own" ON public.product_reviews FOR UPDATE USING (auth.uid() = user_id);
    END IF;
END $$;

-- Users can delete only their own reviews
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'reviews_delete_own') THEN
        CREATE POLICY "reviews_delete_own" ON public.product_reviews FOR DELETE USING (auth.uid() = user_id);
    END IF;
END $$;

-- ── Helper view: rating summary per product ────────────────────────────────
CREATE OR REPLACE VIEW public.product_rating_summary AS
SELECT
  product_id,
  COUNT(*)::INT                                          AS total_reviews,
  ROUND(AVG(rating), 1)                                 AS average_rating,
  COUNT(*) FILTER (WHERE rating = 5)::INT               AS five_star,
  COUNT(*) FILTER (WHERE rating = 4)::INT               AS four_star,
  COUNT(*) FILTER (WHERE rating = 3)::INT               AS three_star,
  COUNT(*) FILTER (WHERE rating = 2)::INT               AS two_star,
  COUNT(*) FILTER (WHERE rating = 1)::INT               AS one_star
FROM public.product_reviews
GROUP BY product_id;
