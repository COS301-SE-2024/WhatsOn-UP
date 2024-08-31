import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UserRecommendationsService } from './user-recommendations.service';
import { EventDto } from './dto/event.dto';
import { GetUserId } from 'src/get-user-id.decorator';

@Controller('events')
export class UserRecommendationsController {
  constructor(private readonly recommendationService: UserRecommendationsService) {}

  @Get('recommended_events')
  async findAll(@GetUserId() userId: string): Promise<EventDto[]> {
    return await this.recommendationService.getRecommendedEvents(userId);
  }
}

