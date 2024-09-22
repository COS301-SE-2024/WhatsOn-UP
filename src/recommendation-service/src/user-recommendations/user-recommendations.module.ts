import { Module } from '@nestjs/common';
import { UserRecommendationsService } from './user-recommendations.service';
import { UserRecommendationsController } from './user-recommendations.controller';
import { SupabaseProvider } from 'src/supabase-provider/supabase-provider';

@Module({
  controllers: [UserRecommendationsController],
  providers: [UserRecommendationsService, SupabaseProvider],
})
export class UserRecommendationsModule {}
