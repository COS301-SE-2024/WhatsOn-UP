import { Injectable } from '@nestjs/common';
import { CreateUserRecommendationDto } from './dto/create-user-recommendation.dto';
import { UpdateUserRecommendationDto } from './dto/update-user-recommendation.dto';

@Injectable()
export class UserRecommendationsService {
  create(createUserRecommendationDto: CreateUserRecommendationDto) {
    return 'This action adds a new userRecommendation';
  }

  findAll() {
    return `This action returns all userRecommendations`;
  }

  findOne(id: number) {
    return `This action returns a #${id} userRecommendation`;
  }

  update(id: number, updateUserRecommendationDto: UpdateUserRecommendationDto) {
    return `This action updates a #${id} userRecommendation`;
  }

  remove(id: number) {
    return `This action removes a #${id} userRecommendation`;
  }
}
