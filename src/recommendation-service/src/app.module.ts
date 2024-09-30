import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserPreferencesModule } from './user-preferences/user-preferences.module';
import { UserRecommendationsModule } from './user-recommendations/user-recommendations.module';
import { SupabaseProvider } from './supabase-provider/supabase-provider';


@Module({
  imports: [UserPreferencesModule, UserRecommendationsModule],
  controllers: [AppController],
  providers: [AppService, SupabaseProvider],
})
export class AppModule {}
