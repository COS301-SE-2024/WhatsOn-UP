import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UserRecommendationsService } from './user-recommendations.service';
import { CreateUserRecommendationDto } from './dto/create-user-recommendation.dto';
import { UpdateUserRecommendationDto } from './dto/update-user-recommendation.dto';

@Controller('user-recommendations')
export class UserRecommendationsController {
  constructor(private readonly userRecommendationsService: UserRecommendationsService) {}

  @Post()
  create(@Body() createUserRecommendationDto: CreateUserRecommendationDto) {
    return this.userRecommendationsService.create(createUserRecommendationDto);
  }

  @Get()
  findAll() {
    return this.userRecommendationsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userRecommendationsService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserRecommendationDto: UpdateUserRecommendationDto) {
    return this.userRecommendationsService.update(+id, updateUserRecommendationDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.userRecommendationsService.remove(+id);
  }
}
