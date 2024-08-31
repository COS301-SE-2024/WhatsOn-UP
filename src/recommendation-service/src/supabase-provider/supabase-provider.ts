// supabase.provider.ts
import { Provider } from '@nestjs/common';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

const SUPABASE_CLIENT = 'SUPABASE_CLIENT';

const SupabaseProvider: Provider<SupabaseClient> = {
  provide: SUPABASE_CLIENT,
  useFactory: (): SupabaseClient => {
  return createClient(
          'https://mehgbhiirnmypfgnkaud.supabase.co',
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1laGdiaGlpcm5teXBmZ25rYXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQwODA0NzAsImV4cCI6MjAzOTY1NjQ3MH0.HvqoJdWdJrDefkJVjx1Y2aUsp33syv0nu4jwfGY4om0'
      );
  },
};

export { SupabaseProvider, SUPABASE_CLIENT};