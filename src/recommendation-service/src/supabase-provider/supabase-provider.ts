// supabase.provider.ts
import { Provider } from '@nestjs/common';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

const SUPABASE_CLIENT = 'SUPABASE_CLIENT';

const SupabaseProvider: Provider<SupabaseClient> = {
  provide: SUPABASE_CLIENT,
  useFactory: (): SupabaseClient => {
  return createClient(
          process.env.SUPABASE_URL,
          process.env.SUPABASE_ANON_KEY
      );
  },
};

export { SupabaseProvider, SUPABASE_CLIENT};