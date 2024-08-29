import { Module } from '@nestjs/common';
import { UserRecommendationsService } from './user-recommendations.service';
import { UserRecommendationsController } from './user-recommendations.controller';

@Module({
  controllers: [UserRecommendationsController],
  providers: [UserRecommendationsService],
})
export class UserRecommendationsModule {}
