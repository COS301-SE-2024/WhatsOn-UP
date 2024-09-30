import { Module } from '@nestjs/common';
import { UserPreferencesService } from './user-preferences.service';
import { UserPreferencesController } from './user-preferences.controller';
import { SupabaseProvider } from 'src/supabase-provider/supabase-provider';

@Module({
  controllers: [UserPreferencesController],
  providers: [UserPreferencesService, SupabaseProvider],
})
export class UserPreferencesModule {}
