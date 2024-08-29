import { PartialType } from '@nestjs/mapped-types';
import { CreateUserRecommendationDto } from './create-user-recommendation.dto';

export class UpdateUserRecommendationDto extends PartialType(CreateUserRecommendationDto) {}
