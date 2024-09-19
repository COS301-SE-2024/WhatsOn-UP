import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UserRecommendationsService } from './user-recommendations.service';
import { EventDto } from './dto/event.dto';
import { extractUserIdFromToken, GetAccessToken } from 'src/auth';

@Controller('events')
export class UserRecommendationsController {
  constructor(private readonly recommendationService: UserRecommendationsService) {}

  @Get('recommended_events')
  async findAll(@GetAccessToken() accessToken: string): Promise<EventDto[]> {
    const userid = extractUserIdFromToken(accessToken);
    return await this.recommendationService.getRecommendedEvents(userid);
  }
}

