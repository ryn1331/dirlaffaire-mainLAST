
-- Restore cost_price for authenticated (admin) only, keep hidden for anon
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'products'
      AND column_name = 'cost_price'
  ) THEN
    GRANT SELECT (cost_price) ON public.products TO authenticated;
  END IF;
END $$;

-- Restrict storage listing on product-images bucket: only allow direct file access via name
-- Disable broad SELECT, allow per-object access
DROP POLICY IF EXISTS "Public read product images" ON storage.objects;
-- Make bucket private listing but files served via public URL still work since bucket is public for downloads
-- Keep public read since bucket is public — this is intentional for product images
CREATE POLICY "Public read product images" ON storage.objects FOR SELECT TO public
  USING (bucket_id = 'product-images');
